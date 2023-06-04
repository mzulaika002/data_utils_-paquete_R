##################################################################################
# El módulo `preprocessing.R` proporciona funciones para realizar tareas comunes #
# de preprocesamiento, como la normalización y estandarización de variables en   #
# un conjunto de datos.                                                          #
# *******************************************************************************#
# Autora:   Muitze Zulaika Gallastegi                                            #
# Fecha:    02/06/2023                                                           #
##################################################################################

#' Normalize a numeric variable using min-max normalization.
#' 
#' @param x A vector or array of numeric values.
#' @return A vector with the normalized values of 'x'.
#' 
#' @examples
#' x <- c(1, 2, 3, 4, 5)
#' normalize_variable(x)
#' 
normalize_variable <- function(x) {
  if (is.null(x)) {
    stop("The argument 'x' cannot be NULL.")
  }
  
  if (!is.numeric(x)) {
    stop("The argument 'x' must be a numeric vector or array.")
  }
  
  if (length(x) == 0) {
    stop("The vector 'x' cannot be empty.")
  }
  
  unique_values <- unique(x)
  if (identical(unique_values, c(0, 1))) {
    return(x)
  }
  
  min_val <- min(x, na.rm = TRUE)
  max_val <- max(x, na.rm = TRUE)
  
  x_normalized <- (x - min_val) / (max_val - min_val)
  
  return(x_normalized)
}

#' Standardize a numeric variable using z-score standardization.
#' 
#' @param x A vector or array of numeric values.
#' @return A vector with the standardized values of 'x'.
#' 
#' @examples
#' x <- c(1, 2, 3, 4, 5)
#' standardize_variable(x)
#' 
standardize_variable <- function(x) {
  if (is.null(x)) {
    stop("The argument 'x' cannot be NULL.")
  }
  
  if (!is.numeric(x)) {
    stop("The argument 'x' must be a numeric vector or array.")
  }
  
  if (length(x) == 0) {
    stop("The vector 'x' cannot be empty.")
  }
  
  unique_values <- unique(x)
  if (identical(unique_values, c(0, 1))) {
    return(x)
  }
  
  mean_val <- mean(x, na.rm = TRUE)
  std_dev <- sd(x, na.rm = TRUE)
  
  x_standardized <- (x - mean_val) / std_dev
  
  return(x_standardized)
}

#' Normalize all numeric variables in a dataset.
#' 
#' @param dataset A dataset (data frame or similar).
#' @return A new dataset with normalized numeric variables.
#' 
normalize_dataset <- function(dataset) {
  if (is.null(dataset)) {
    stop("The argument 'dataset' cannot be NULL.")
  }
  
  if (!is.data.frame(dataset)) {
    stop("The argument 'dataset' must be a data frame or similar.")
  }
  
  normalized_dataset <- dataset
  
  for (attribute in colnames(normalized_dataset)) {
    values <- normalized_dataset[[attribute]]
    if (is.numeric(values)) {
      normalized_values <- normalize_variable(values)
      normalized_dataset[[attribute]] <- normalized_values
    }
  }
  
  return(normalized_dataset)
}

#' Standardize all numeric variables in a dataset.
#' 
#' @param dataset A dataset (data frame or similar).
#' @return A new dataset with standardized numeric variables.
#' 
standardize_dataset <- function(dataset) {
  if (is.null(dataset)) {
    stop("The argument 'dataset' cannot be NULL.")
  }
  
  if (!is.data.frame(dataset)) {
    stop("The argument 'dataset' must be a data frame or similar.")
  }
  
  standardized_dataset <- dataset
  
  for (attribute in colnames(standardized_dataset)) {
    values <- standardized_dataset[[attribute]]
    if (is.numeric(values)) {
      standardized_values <- standardize_variable(values)
      standardized_dataset[[attribute]] <- standardized_values
    }
  }
  
  return(standardized_dataset)
}
