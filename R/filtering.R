################################################################################
# El módulo 'Filtering.R' tiene una funciones para filtrar las variables de un   #
# conjunto de datos según diferentes métricas y criterios de umbral.          #
# *****************************************************************************#
# Autora:   Muitze Zulaika Gallastegi                                          #
# Fecha:    02/06/2023                                                         #
################################################################################

#' Filter the variables of the dataset based on the specified metric and threshold criteria.
#' 
#' @param dataset (data.frame) A data frame containing the dataset.
#' @param metric (character) The metric to use for filtering the variables.
#'        Can be 'entropy', 'variance', or 'auc'.
#' @param threshold (numeric) The threshold value to compare with the metric.
#' @param operator (character) The operator to use for comparing the metric with the threshold.
#'        Can be '>', '<', or '=='.
#' @param class_attribute (character) Optional name of the class attribute used for calculating AUC.
#' @return A new data frame containing the filtered variables.
#' 
#' @examples
#' dataset <- data.frame(A = c(1, 2, 3, 4, 5), B = c(2.5, 4.5, 6.5, 8.5, 10.5), Class = c(0, 1, 1, 0, 1))
#' filter_variables(dataset, "variance", 5, ">")
#' 
filter_variables <- function(dataset, metric, threshold, operator, class_attribute = NULL) {
  attributes <- colnames(dataset)
  filtered_data <- data.frame()
  
  for (attribute in attributes) {
    metric_value <- NULL
    
    if (metric == "entropy") {
      metric_value <- calculate_attribute_entropy(dataset, attribute)
    } else if (metric == "variance") {
      metric_value <- calculate_attribute_variance(dataset, attribute)
    } else if (metric == "auc") {
      if (is.null(class_attribute)) {
        stop("The 'class_attribute' parameter is required for metric 'auc'.")
      }
      metric_value <- calculate_attribute_auc(dataset, attribute, class_attribute)
    } else {
      print(paste("Invalid metric: '", metric, "'", sep = ""))
      return(NULL)
    }
    
    if (!is.null(metric_value)) {
      if (operator == ">" && metric_value > threshold) {
        filtered_data[[attribute]] <- dataset[[attribute]]
      } else if (operator == "<" && metric_value < threshold) {
        filtered_data[[attribute]] <- dataset[[attribute]]
      } else if (operator == "==" && metric_value == threshold) {
        filtered_data[[attribute]] <- dataset[[attribute]]
      }
    }
  }
  
  if (is.data.frame(filtered_data) && nrow(filtered_data) == 0) {
    print("No attributes meet the specified conditions.")
  }
  
  return(filtered_data)
}
