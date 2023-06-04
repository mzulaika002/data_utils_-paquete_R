################################################################################
# Este script "discretization.R" proporcion funciones para realizar la        #
# discretización de atributos numéricos en un conjunto de datos. Proporciona   #
# dos métodos de discretización: Equal Width (ancho igual) y Equal Frequency   #
# (frecuencia igual).                                                          #
# *****************************************************************************#
# Autora:   Muitze Zulaika Gallastegi                                          #
# Fecha:    02/06/2023                                                         #
################################################################################

#' Discretize an input attribute using Equal Width discretization.
#' 
#' Discretize an input attribute `x` into `num_bins` intervals using Equal Width discretization.
#' 
#' @param x (vector) A vector of numeric values.
#' @param num_bins (integer) The number of intervals to discretize `x` into.
#' @return A list with two elements:
#'   - `x_discretized`: A list of discretized values represented as strings in the form "I<n>",
#'                      where <n> is the interval index.
#'   - `cut_points`: A list of cut points between intervals.
#' 
#' @examples
#' x <- c(1, 2, 3, 4, 5)
#' num_bins <- 3
#' discretizeEW(x, num_bins)
#' 
discretizeEW <- function(x, num_bins) {
  if (num_bins <= 0) {
    stop("The number of intervals must be greater than zero.")
  }
  
  if (is.list(x)) {
    x <- unlist(x)
  } else if (is.data.frame(x)) {
    x <- unlist(x)
  } else if (!is.numeric(x)) {
    stop("The argument 'x' must be a vector or a data frame.")
  }

  if (length(x) == 0) {
    stop("The list of values is empty.")
  }

  if (!is.numeric(x)) {
    stop("The attribute values must be numeric.")
  }

  # Determine the maximum and minimum values in the list
  max_val <- max(x, na.rm = TRUE)
  min_val <- min(x, na.rm = TRUE)

  # Calculate the size of each interval
  bin_size <- (max_val - min_val) / num_bins

  # Create a list of cut points for each interval
  cut_points <- seq(min_val + bin_size, max_val, by = bin_size)

  # Create an empty list to store the grouped values
  x_discretized <- vector("list", length(x))

  # Iterate over the values in the list and assign them to an interval
  for (i in seq_along(x)) {
    val <- x[i]
    for (j in seq_along(cut_points)) {
      cut_point <- cut_points[j]
      if (val < cut_point) {
        x_discretized[[i]] <- paste0("I", j)
        break
      }
    }
    if (is.null(x_discretized[[i]])) {
      x_discretized[[i]] <- paste0("I", num_bins)
    }
  }

  return(list(x_discretized = x_discretized, cut_points = cut_points))
}

#' Discretize an input attribute using Equal Frequency discretization.
#' 
#' Discretize an input attribute `x` into `num_bins` intervals using Equal Frequency discretization.
#' 
#' @param x (vector) A vector of numeric values.
#' @param num_bins (integer) The number of intervals to discretize `x` into.
#' @return A list with two elements:
#'   - `x_discretized`: A list of discretized values represented as strings in the form "I<n>",
#'                      where <n> is the interval index.
#'   - `cut_points`: A list of cut points between intervals.
#' 
#' @examples
#' x <- c(1, 2, 3, 4, 5)
#' num_bins <- 3
#' discretizeEF(x, num_bins)
#' 
discretizeEF <- function(x, num_bins) {
  if (num_bins <= 0) {
    stop("The number of intervals must be greater than zero.")
  }
  if (num_bins >= length(x)) {
    stop("The number of bins must be less than the number of values in the attribute.")
  }
  if (is.list(x)) {
    x <- unlist(x)
  } else if (is.data.frame(x)) {
    x <- unlist(x)
  } else if (!is.numeric(x)) {
    stop("The argument 'x' must be a vector or a data frame.")
  }
  if (length(x) == 0) {
    stop("The list of values is empty.")
  }
  if (!is.numeric(x)) {
    stop("The attribute values must be numeric.")
  }
  
  # Sort x in ascending order
  x_sorted <- sort(x)
  
  # Calculate the number of elements per interval
  elements_per_interval <- length(x) / num_bins
  
  # Create a list of cut points
  cut_points <- sapply(1:num_bins, function(i) x_sorted[as.integer(i * elements_per_interval)])
  
  # Initialize a list for discretized values
  x_discretized <- vector("list", length(x))
  
  # Iterate over elements in x and find the interval they belong to
  for (i in seq_along(x)) {
    element <- x[i]
    for (j in seq_along(cut_points)) {
      cut_point <- cut_points[j]
      if (element <= cut_point) {
        x_discretized[[i]] <- paste0("I", j)
        break
      }
    }
    if (is.null(x_discretized[[i]])) {
      x_discretized[[i]] <- paste0("I", num_bins)
    }
  }
  
  return(list(x_discretized = x_discretized, cut_points = cut_points))
}

#' Discretize input values `x` into intervals defined by cut points.
#' 
#' @param x (vector) A vector of numeric values to discretize.
#' @param cut_points (vector) A vector of cut points that define the intervals.
#' @return A list with two elements:
#'   - `x_discretized`: A list of discretized values represented as strings in the form "I<n>",
#'                      where <n> is the interval index.
#'   - `cut_points`: The original list of cut points, unchanged.
#' 
#' @examples
#' x <- c(1, 2, 3, 4, 5)
#' cut_points <- c(2, 4)
#' discretize(x, cut_points)
#' 
discretize <- function(x, cut_points) {
  if (is.list(x)) {
    x <- unlist(x)
  } else if (is.data.frame(x)) {
    x <- unlist(x)
  } else if (!is.numeric(x)) {
    stop("The argument 'x' must be a vector or a data frame.")
  }
  if (is.list(cut_points)) {
    cut_points <- unlist(cut_points)
  } else if (is.data.frame(cut_points)) {
    cut_points <- unlist(cut_points)
  } else if (!is.numeric(cut_points)) {
    stop("The argument 'cut_points' must be a vector or a data frame.")
  }
  if (length(x) == 0) {
    stop("The argument 'x' is empty.")
  }
  if (length(cut_points) == 0) {
    stop("The argument 'cut_points' is empty.")
  }
  if (!is.numeric(x)) {
    stop("The values of the 'x' attribute must be numeric.")
  }
  if (!is.numeric(cut_points)) {
    stop("The values of the 'cut_points' attribute must be numeric.")
  }
  
  # Verify that the cut points are in ascending order
  if (!identical(cut_points, sort(cut_points))) {
    stop("The cut points must be in ascending order.")
  }
  
  # Initialize a list for discretized values
  x_discretized <- vector("list", length(x))
  
  # Iterate over the elements in x and find the interval they belong to
  for (i in seq_along(x)) {
    element <- x[i]
    for (j in seq_along(cut_points)) {
      cut_point <- cut_points[j]
      if (element <= cut_point) {
        x_discretized[[i]] <- paste0("I", j+1)
        break
      }
    }
    if (is.null(x_discretized[[i]])) {
      x_discretized[[i]] <- paste0("I", length(cut_points)+1)
    }
  }
  
  return(list(x_discretized = x_discretized, cut_points = cut_points))
}

#' Discretize an attribute using the specified method.
#' 
#' @param attribute (vector) An attribute represented as a vector.
#' @param num_bins (numeric or vector) The number of bins to discretize each attribute of the dataset.
#' @param method (character) The discretization method to use. Can be 'equal_width' or 'equal_frequency'.
#' @return A list with two elements:
#'   - `discretized_attribute`: A new attribute with discretized values. A list of discretized values
#'                             represented as strings in the form "I<n>", where <n> is the interval index.
#'   - `cut_points`: The list of cut points used for discretization.
#' 
#' @examples
#' attribute <- c(1, 2, 3, 4, 5)
#' num_bins <- 3
#' method <- "equal_width"
#' discretize_attribute(attribute, num_bins, method)
#' 
discretize_attribute <- function(attribute, num_bins, method) {
  if (method != "equal_width" && method != "equal_frequency") {
    stop("Invalid discretization method. Use 'equal_width' or 'equal_frequency'.")
  }
  
  if (method == "equal_width") {
    result <- discretizeEW(attribute, num_bins)
  } else if (method == "equal_frequency") {
    result <- discretizeEF(attribute, num_bins)
  }
  
  return(result)
}

#' Discretize a dataset using the specified method.
#' 
#' @param dataset (list) A dataset represented as a list of vectors.
#' @param num_bins (numeric) The number of bins to discretize each attribute of the dataset.
#' @param method (character) The discretization method to use. Can be 'equal_width' or 'equal_frequency'.
#' @return A list representing the discretized dataset.
#' 
#' @examples
#' dataset <- list(
#'   attribute1 = c(1, 2, 3, 4, 5),
#'   attribute2 = c(1.5, 2.5, 3.5, 4.5, 5.5),
#'   attribute3 = c("A", "B", "C", "D", "E")
#' )
#' num_bins <- 3
#' method <- "equal_width"
#' discretize_dataset(dataset, num_bins, method)
#' 
discretize_dataset <- function(dataset, num_bins, method) {
  if (method != "equal_width" && method != "equal_frequency") {
    stop("Invalid discretization method. Use 'equal_width' or 'equal_frequency'.")
  }
  
  discretized_dataset <- list()
  
  for (attribute in names(dataset)) {
    attribute_values <- dataset[[attribute]]
    
    if (is.numeric(attribute_values)) {
      if (method == "equal_width") {
        result <- discretizeEW(attribute_values, num_bins)
      } else if (method == "equal_frequency") {
        result <- discretizeEF(attribute_values, num_bins)
      }
      
      discretized_dataset[[attribute]] <- result[[1]]
    } else {
      discretized_dataset[[attribute]] <- attribute_values
    }
  }
  
  return(discretized_dataset)
}
