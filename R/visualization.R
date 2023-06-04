################################################################################
# Este script "visualization.R" proporciona la definición de varias funciones #
# de visualización de las métricas utilizando la biblioteca Matplotlib         #
# *****************************************************************************#
# Autora:   Muitze Zulaika Gallastegi                                          #
# Fecha:    02/06/2023                                                         #
################################################################################

# CARGAR LIBRERIAS -------------------------------------------------------------
library(ggplot2)

# FUNCIONES --------------------------------------------------------------------

plot_entropy <- function(entropy_values, attribute_names) {
  data <- data.frame(Entropy = entropy_values, Attribute = attribute_names)
  
  ggplot(data, aes(x = Attribute, y = Entropy)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(x = "Atributo", y = "Entropía", title = "Valores de Entropía") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
    coord_flip()
}

plot_variance <- function(variance_values, attribute_names) {
  data <- data.frame(Variance = variance_values, Attribute = attribute_names)
  
  ggplot(data, aes(x = Attribute, y = Variance)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(x = "Atributo", y = "Varianza", title = "Valores de Varianza") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
    coord_flip()
}

plot_auc <- function(auc_values) {
  data <- data.frame(AUC = auc_values)
  
  ggplot(data, aes(x = seq_along(AUC), y = AUC)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(x = "Atributo", y = "AUC", title = "Valores de AUC") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
    coord_flip()
}

plot_correlation_matrix <- function(correlation_matrix) {
  plt <- heatmap(correlation_matrix,
                 col = colorRampPalette(c("yellow", "orange", "brown"))(100),
                 main = "Matriz de Correlación",
                 xlab = "",
                 ylab = "")
  print(plt)
}

plot_roc_auc <- function(dataset, attribute, class_attribute) {
  tryCatch({
    attribute_values <- dataset[[attribute]]
    class_labels <- dataset[[class_attribute]]
    
    if (!is.factor(attribute_values) && !is.factor(class_labels)) {
      auc_result <- calculate_auc(attribute_values, class_labels)
      tpr_values <- auc_result$tpr_values
      fpr_values <- auc_result$fpr_values
      auc <- auc_result$auc
      
      plt <- plot(fpr_values, tpr_values, type = "l", xlim = c(0, 1), ylim = c(0, 1.05),
                  xlab = "False Positive Rate", ylab = "True Positive Rate",
                  main = paste("ROC Curve - Attribute:", attribute, ", Class Attribute:", class_attribute),
                  lwd = 2)
      abline(a = 0, b = 1, lty = 2)
      legend("bottomright", legend = paste("AUC =", round(auc, 2)), lwd = 2)
      print(plt)
    } else {
      stop(paste("El atributo '", attribute, "' o el atributo de clase '", class_attribute, "' no son continuos.", sep = ""))
    }
  }, error = function(e) {
    print(e)
  })
}
