## Sorensen
sorensen_index <- function(data1, data2) {
  intersection = length(intersect(rownames(data1), rownames(data2)))
  
  return(2*intersection/(nrow(data1) + nrow(data2)))
}

## PSS
pssi <- function(data, c1_col, c2_col, step, method = "two-side") {
  
  step <- step / 100
  
  c1_col_name <- deparse(substitute(c1_col))
  c2_col_name <- deparse(substitute(c2_col))
  
  if (!all(c1_col_name %in% colnames(data) && c2_col_name %in% colnames(data))) {
    stop("Invalid column names. Please check the column names.")
  }
  
  if (nrow(data[complete.cases(data), ]) < nrow(data)) {
    stop("Vector lengths not equal (check for missing values)")
  } else {
    
    comp <- c()
    weights <- c()
    
    for (i in seq(from = step, to = 0.5, by = step)) {
      
      sorensen_left <- sorensen_index(data[data[[c1_col_name]] <= quantile(data[[c1_col_name]], i), ], 
                                      data[data[[c2_col_name]] <= quantile(data[[c2_col_name]], i), ])
      
      sorensen_right <- sorensen_index(data[data[[c1_col_name]] >= quantile(data[[c1_col_name]], 1 - i), ], 
                                       data[data[[c2_col_name]] >= quantile(data[[c2_col_name]], 1 - i), ])
      
      weight <- 1 - i
      
      if (method == "two-side") {
        comp <- c(comp, mean(c(sorensen_left, sorensen_right)) * weight)
      } else if (method == "left-side") {
        comp <- c(comp, sorensen_left * weight)
      } else if (method == "right-side") {
        comp <- c(comp, sorensen_right * weight)
      }
      
      weights <- c(weights, weight)
    }
    
    index <- sum(comp) / sum(weights)
    
    return(index)
  }
}
