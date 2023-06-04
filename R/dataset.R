################################################################################
# Este script "dataset.R" proporciona una clase Dataset para trabajar         #
# con conjuntos de datos: cargar, modificar y analizar conjuntos de datos      #
# de forma sencilla                                                            #
# **************************************************************************** #
# Autora:   Muitze Zulaika Gallastegi                                          #
# Fecha:    02/06/2023                                                         #
################################################################################

#' Clase Dataset para trabajar con conjuntos de datos
#' 
#' @slot data DataFrame de pandas que contiene los datos del conjunto de datos
#' 
Dataset <- setClass(Class="Dataset",
                    slots=list(data="data.frame"))

#' Muestra la guía de usuario con las funciones disponibles
#' 
show_help <- function() {
  help_text <- "
        Las funciones disponibles:
        
        1.  read_data(file_path): Lee los datos desde un archivo y los carga en el objeto Dataset.
        2.  write_data(file_path): Escribe los datos del objeto Dataset en un archivo.
        3.  get_attribute(attribute): Obtiene los valores de un atributo específico del conjunto de datos.
        4.  add_attribute(attribute, values): Establece los valores de un nuevo atributo específico en el conjunto de datos.
        5.  set_attribute(attribute, values): Establece los valores de un atributo específico en el conjunto de datos.
        6.  get_attributes(): Obtiene una lista de los nombres de los atributos en el conjunto de datos.
        7.  get_data(): Obtiene el DataFrame de pandas que representa los datos del conjunto de datos.
        8.  empty(): Comprueba si el objeto Dataset está vacío.
        9.  copy(): Crea una copia del objeto Dataset.
        10. num_attributes(): Obtiene el número de atributos en el conjunto de datos.
        11. get_column(i): Obtiene una columna específica del conjunto de datos."
  cat(help_text)
}


#' Inicializa un objeto Dataset
#' 
#' @param data DataFrame de pandas opcional que contiene los datos del conjunto de datos.
#' 
initialize <- function(.Object, data=NULL) {
  if (is.null(data)) {
    .Object@data <- data.frame()  # Crea un DataFrame vacío si no se proporcionan datos
  } else {
    .Object@data <- data.frame(data)  # Convierte los datos en un DataFrame
  }
  .Object
}

#' Lee los datos desde un archivo y los carga en el objeto Dataset
#' 
#' @param file_path Ruta del archivo que contiene los datos.
#' @return El objeto Dataset con los datos cargados.
#' 
read_data <- function(.Object, file_path) {
  .Object@data <- read.csv(file_path)  # Lectura de datos desde un archivo CSV
  .Object
}

#' Escribe los datos del objeto Dataset en un archivo
#' 
#' @param file_path Ruta del archivo donde se guardarán los datos.
#' 
write_data <- function(.Object, file_path) {
  write.csv(.Object@data, file_path, row.names=FALSE)  # Escritura de datos a un archivo CSV
}

#' Obtiene los valores de un atributo específico del conjunto de datos
#' 
#' @param attribute Nombre del atributo deseado.
#' @return Serie de pandas que contiene los valores del atributo especificado.
#' 
get_attribute <- function(.Object, attribute) {
  if (attribute %in% colnames(.Object@data)) {
    return(.Object@data[[attribute]])
  } else {
    stop(paste("El atributo '", attribute, "' no existe en el conjunto de datos."))
  }
}

#' Establece los valores de un nuevo atributo específico en el conjunto de datos
#' 
#' @param attribute Nombre del atributo a establecer.
#' @param values Valores a asignar al atributo.
#' 
add_attribute <- function(.Object, attribute, values) {
  if (attribute %in% colnames(.Object@data)) {
    stop(paste("El atributo '", attribute, "' ya existe en el conjunto de datos. Si quieres modificarlo, usa la función 'set_attribute(attribute, values)'."))
  } else {
    .Object@data[[attribute]] <- values
  }
}

#' Establece los valores de un atributo específico en el conjunto de datos
#' 
#' @param attribute Nombre del atributo a establecer.
#' @param values Valores a asignar al atributo.
#' 
set_attribute <- function(.Object, attribute, values) {
  if (attribute %in% colnames(.Object@data)) {
    .Object@data[[attribute]] <- values
  } else {
    stop(paste("El atributo '", attribute, "' no existe en el conjunto de datos. Si quieres crear un nuevo atributo, usa la función 'add_attribute(attribute, values)'."))
  }
}

#' Obtiene una lista de los nombres de los atributos en el conjunto de datos
#' 
#' @return Lista de strings que representa los nombres de los atributos.
#' 
get_attributes <- function(.Object) {
  return(colnames(.Object@data))
}

#' Obtiene el DataFrame de pandas que representa los datos del conjunto de datos
#' 
#' @return DataFrame de pandas que contiene los datos del conjunto de datos.
#' 
get_data <- function(.Object) {
  return(.Object@data)
}

#' Comprueba si el objeto Dataset está vacío
#' 
#' @return TRUE si el objeto Dataset está vacío, FALSE de lo contrario.
#' 
empty <- function(.Object) {
  return(nrow(.Object@data) == 0)
}

#' Crea una copia del objeto Dataset
#' 
#' @return Nuevo objeto Dataset que es una copia del objeto actual.
#' 
copy <- function(.Object) {
  return(new("Dataset", data=.Object@data))
}

#' Obtiene el número de atributos en el conjunto de datos
#' 
#' @return Entero que representa el número de atributos.
#' 
num_attributes <- function(.Object) {
  return(ncol(.Object@data))
}

#' Obtiene una columna específica del conjunto de datos
#' 
#' @param i Índice de la columna deseada.
#' @return Serie de pandas que contiene los valores de la columna especificada.
#' 
get_column <- function(.Object, i) {
  if (i >= 1 && i <= ncol(.Object@data)) {
    return(.Object@data[, i])
  } else {
    stop("El índice está fuera de rango.")
  }
}
