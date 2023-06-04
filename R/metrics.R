################################################################################
# El script 'metrics.R' incluye diferentes funciones relacionadas con la      #
# entropía, la varianza y el cálculo del área bajo la curva ROC (AUC).         #
# *****************************************************************************#
# Autora:   Muitze Zulaika Gallastegi                                          #
# Fecha:    02/06/2023                                                         #
################################################################################

#' Calculate the entropy of a discrete attribute.
#' 
#' @param attribute_values (vector) A vector containing the values of the discrete attribute.
#' @return The entropy value of the attribute.
#' 
#' @examples
#' attribute_values <- c("A", "B", "A", "C", "B")
#' calculate_entropy(attribute_values)
#' 
calculate_entropy <- function(attribute_values) {
  value_counts <- table(attribute_values)
  probabilities <- value_counts / length(attribute_values)
  entropy <- -sum(probabilities * log2(probabilities))
  return(entropy)
}

#' Calculate the variance of a continuous attribute.
#' 
#' @param attribute_values (vector) A vector containing the values of the continuous attribute.
#' @return The variance value of the attribute.
#' 
#' @examples
#' attribute_values <- c(1, 2, 3, 4, 5)
#' calculate_variance(attribute_values)
#' 
calculate_variance <- function(attribute_values) {
  mean <- mean(attribute_values)
  variance <- mean((attribute_values - mean)^2)
  return(variance)
}


#' Calculate the area under the ROC curve (AUC) of a continuous attribute with respect to class labels.
#' 
#' @param attribute_values (vector) A vector containing the values of the continuous attribute.
#' @param class_labels (vector) A vector containing the binary class labels (0 or 1).
#' @return A list containing the true positive rate (TPR) values, false positive rate (FPR) values, and the AUC value.
#' 
#' @examples
#' attribute_values <- c(1, 2, 3, 4, 5)
#' class_labels <- c(0, 1, 1, 0, 1)
#' calculate_auc(attribute_values, class_labels)
#' 
calculate_auc <- function(attribute_values, class_labels) {
  sorted_indices <- order(attribute_values)
  sorted_attribute <- attribute_values[sorted_indices]
  sorted_labels <- class_labels[sorted_indices]

  n_positives <- sum(sorted_labels == 1)
  n_negatives <- sum(sorted_labels == 0)

  if (n_positives == 0 || n_negatives == 0) {
    return(list(tpr_values = NaN, fpr_values = NaN, auc = NaN))
  }

  tpr_values <- vector()
  fpr_values <- vector()
  tpr <- 0
  fpr <- 0
  last_label <- sorted_labels[1]

  for (i in 1:length(sorted_labels)) {
    if (sorted_labels[i] != last_label) {
      tpr_values <- c(tpr_values, tpr)
      fpr_values <- c(fpr_values, fpr)
      last_label <- sorted_labels[i]
    }

    if (sorted_labels[i] == 1) {
      tpr <- tpr + 1
    } else {
      fpr <- fpr + 1
    }
  }

  tpr_values <- c(tpr_values, tpr) / n_positives
  fpr_values <- c(fpr_values, fpr) / n_negatives

  auc <- trapz(fpr_values, tpr_values)

  return(list(tpr_values = tpr_values, fpr_values = fpr_values, auc = auc))
}

#' Calculate the entropy of a specific attribute in the dataset.
#' 
#' @param dataset (data.frame) A data frame containing the dataset.
#' @param attribute (character) The name of the attribute to calculate the entropy.
#' @return The entropy value of the attribute.
#' 
#' @examples
#' dataset <- data.frame(A = c(1, 2, 3, 4, 5), B = c("A", "B", "A", "B", "A"))
#' calculate_attribute_entropy(dataset, "B")
#' 
calculate_attribute_entropy <- function(dataset, attribute) {
  if (!(attribute %in% colnames(dataset))) {
    stop("The attribute '", attribute, "' does not exist in the dataset.")
  }
  
  attribute_values <- dataset[, attribute]
  
  if (is.factor(attribute_values)) {
    return(calculate_entropy(attribute_values))
  } else if (is.integer(attribute_values) && all(attribute_values %% 1 == 0)) {
    return(calculate_entropy(attribute_values))
  } else {
    stop("The attribute '", attribute, "' is not discrete.")
  }
}


#' Calculate the variance of a specific attribute in the dataset.
#' 
#' @param dataset (data.frame) A data frame containing the dataset.
#' @param attribute (character) The name of the attribute to calculate the variance.
#' @return The variance value of the attribute.
#' 
#' @examples
#' dataset <- data.frame(A = c(1, 2, 3, 4, 5), B = c(2.5, 4.5, 6.5, 8.5, 10.5))
#' calculate_attribute_variance(dataset, "B")
#' 
calculate_attribute_variance <- function(dataset, attribute) {
  if (!(attribute %in% colnames(dataset))) {
    stop("The attribute '", attribute, "' does not exist in the dataset.")
  }
  
  attribute_values <- dataset[, attribute]
  
  if (is.numeric(attribute_values) && any(!attribute_values %% 1 != 0)) {
    return(calculate_variance(attribute_values))
  } else {
    stop("The attribute '", attribute, "' is not continuous.")
  }
}


#' Calculate the AUC of a specific attribute in the dataset relative to the class attribute.
#' 
#' @param dataset (data.frame) A data frame containing the dataset.
#' @param attribute (character) The name of the attribute to calculate the AUC.
#' @param class_attribute (character) The name of the binary class attribute.
#' @return The AUC value of the attribute.
#' 
#' @examples
#' dataset <- data.frame(A = c(1, 2, 3, 4, 5), B = c(2.5, 4.5, 6.5, 8.5, 10.5), Class = c(0, 1, 1, 0, 1))
#' calculate_attribute_auc(dataset, "B", "Class")
#' 
calculate_attribute_auc <- function(dataset, attribute, class_attribute) {
  if (!(attribute %in% colnames(dataset))) {
    stop("The attribute '", attribute, "' does not exist in the dataset.")
  }
  
  if (!(class_attribute %in% colnames(dataset))) {
    stop("The class attribute '", class_attribute, "' does not exist in the dataset.")
  }
  
  attribute_values <- dataset[, attribute]
  class_labels <- dataset[, class_attribute]
  
  if (!is.character(attribute_values) && !is.character(class_labels)) {
    return(calculate_auc(attribute_values, class_labels))
  } else {
    stop("The attribute '", attribute, "' or the class attribute '", class_attribute, "' is not continuous.")
  }
}
