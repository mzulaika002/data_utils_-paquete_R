################################################################################
# El script "correlation.R" contiene funciones para calcular                  #
# la correlación entre variables numéricas y la información mutua              #
# entre variables categóricas.                                                 #
# *****************************************************************************#
# Autora:   Muitze Zulaika Gallastegi                                          #
# Fecha:    02/06/2023                                                         #
################################################################################

#' Calculate the correlation between two variables in a dataset.
#' 
#' @param dataset An object (data frame or similar) containing the data.
#' @param variable1 Name of the first variable.
#' @param variable2 Name of the second variable.
#' @return The correlation coefficient between the two variables.
#' 
calculate_correlation <- function(dataset, variable1, variable2) {
  if (is.null(dataset)) {
    stop("The argument 'dataset' cannot be NULL.")
  }
  
  if (!is.data.frame(dataset)) {
    stop("The argument 'dataset' must be a data frame or similar.")
  }
  
  data_types <- sapply(dataset, class)
  values1 <- dataset[[variable1]]
  values2 <- dataset[[variable2]]
  
  tryCatch({
    if ((data_types[variable1] == "character" && data_types[variable2] != "character") ||
        (data_types[variable2] == "character" && data_types[variable1] != "character")) {
      stop("The variables must be numeric or categorical.")
    } else if (data_types[variable1] == "character" && data_types[variable2] == "character") {
      # Calculate mutual information for categorical variables
      return(calculate_categorical_mutual_information(variable1, variable2, dataset))
    } else {
      # Calculate correlation for numeric variables
      return(calculate_numeric_correlation(values1, values2))
    }
  }, error = function(e) {
    cat("Error:", conditionMessage(e), "\n")
    return(NULL)
  })
}

#' Calculate the correlation (mutual information for categorical variables) pairwise between the variables in the dataset.
#' 
#' @param dataset An object (data frame or similar) containing the data.
#' @return A data frame that contains the correlation matrix.
#' 
calculate_correlation_matrix <- function(dataset) {
  if (is.null(dataset)) {
    stop("The argument 'dataset' cannot be NULL.")
  }
  
  if (!is.data.frame(dataset)) {
    stop("The argument 'dataset' must be a data frame or similar.")
  }
  
  attributes <- colnames(dataset)
  correlation_matrix <- data.frame(matrix(0, nrow = length(attributes), ncol = length(attributes)))
  colnames(correlation_matrix) <- attributes
  
  data_types <- sapply(dataset, class)
  
  for (i in 1:length(attributes)) {
    column1 <- attributes[i]
    correlation_row <- vector()
    
    for (j in 1:length(attributes)) {
      column2 <- attributes[j]
      
      if (column1 == column2) {
        correlation_row <- c(correlation_row, 1.0)  # The correlation of a variable with itself is 1.0
      } else {
        if ((data_types[column1] == "character" && data_types[column2] != "character") ||
            (data_types[column2] == "character" && data_types[column1] != "character")) {
          correlation <- 0.0
        } else if (data_types[column1] == "character" && data_types[column2] == "character") {
          # Categorical variables, calculate mutual information
          correlation <- calculate_categorical_mutual_information(column1, column2, dataset)
        } else {
          # Numeric variables, calculate correlation
          correlation <- calculate_numeric_correlation(dataset[[column1]], dataset[[column2]])
        }
        
        correlation_row <- c(correlation_row, correlation)
      }
    }
    
    correlation_matrix[i, ] <- correlation_row
  }
  
  return(correlation_matrix)
}

#' Calculate the correlation coefficient between two numeric variables.
#' 
#' @param values1 Values of the first variable.
#' @param values2 Values of the second variable.
#' @return Correlation coefficient between the two variables.
#' 
calculate_numeric_correlation <- function(values1, values2) {
  if (length(values1) != length(values2)) {
    stop("The lengths of 'values1' and 'values2' must be equal.")
  }
  
  n <- length(values1)
  mean1 <- sum(values1) / n
  mean2 <- sum(values2) / n
  cov <- sum((values1 - mean1) * (values2 - mean2)) / n
  std1 <- sqrt(sum((values1 - mean1) ^ 2) / n)
  std2 <- sqrt(sum((values2 - mean2) ^ 2) / n)
  correlation <- cov / (std1 * std2)
  
  return(correlation)
}

#' Calculate the mutual information between two categorical variables.
#' 
#' @param variable1 Name of the first variable.
#' @param variable2 Name of the second variable.
#' @param data DataFrame that contains the data.
#' @return Mutual information between the two variables.
#' 
calculate_categorical_mutual_information <- function(variable1, variable2, data) {
  n <- nrow(data)
  unique_values1 <- unique(data[[variable1]])
  unique_values2 <- unique(data[[variable2]])
  mutual_information <- 0.0
  
  for (value1 in unique_values1) {
    p1 <- sum(data[[variable1]] == value1) / n
    for (value2 in unique_values2) {
      p2 <- sum(data[[variable2]] == value2) / n
      p12 <- sum(data[[variable1]] == value1 & data[[variable2]] == value2) / n
      if (p12 > 0) {
        mutual_information <- mutual_information + p12 * log(p12 / (p1 * p2))
      }
    }
  }
  
  return(mutual_information)
}
