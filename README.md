# Introducción

El paquete **datasetUtils** proporciona un conjunto de funciones para operaciones comunes en conjuntos de datos, como la discretización de datos, el cálculo de métricas, el preprocesamiento de variables, la filtración de variables y el cálculo de correlaciones. En esta viñeta, exploraremos las principales funcionalidades del paquete.

# Instalación

Para instalar el paquete `datasetUtils`, puedes utilizar el siguiente código:

```{r eval=FALSE}
install.packages("datasetUtils")
```

# 1. Conjunto de datos

## 1.1. Creación de un conjunto de datos

El primer paso es crear un objeto `Dataset`. Puedes inicializar un `Dataset` vacío o cargar datos desde un archivo.

```{r}
library(datasetUtils)

# Crear un Dataset vacío
data <- Dataset()

# Cargar datos desde un archivo
data <- read_data(data, "Student_bucketing.csv")
```

## 1.2. Visualización del conjunto de datos

Puedes ver los atributos y los datos del objeto `Dataset`.

```{r}
# Obtener los atributos
attributes <- get_attributes(data)
print(attributes)

# Obtener los datos
dataset <- get_data(data)
head(dataset)
```

## 1.3. Modificación del conjunto de datos

La clase `Dataset` proporciona funciones para añadir y establecer atributos en el conjunto de datos.

```{r}
# Añadir un nuevo atributo
add_attribute(data, "new_attribute", values)

# Establecer valores para un atributo
set_attribute(data, "attribute_name", new_values)
```

## 1.4. Guardar el conjunto de datos

Puedes guardar el conjunto de datos en un archivo.

```{r}
write_data(data, "path/to/output.csv")
```


# 2. Discretización

## 2.1 Discretización de ancho igual

La función `discretizeEW` se puede utilizar para realizar una discretización de ancho igual en un atributo numérico. Divide los valores del atributo en un número especificado de intervalos de ancho igual.

```{r}
# Ejemplo de uso
x <- c(1, 2, 3, 4, 5)
num_bins <- 3
discretizeEW(x, num_bins)
```

## 2.2. Discretización de frecuencia igual

La función `discretizeEF` realiza una discretización de frecuencia igual en un atributo numérico. Divide los valores del atributo en un número especificado de intervalos, asegurando que cada intervalo contenga un número igual de valores.

```{r}
# Ejemplo de uso
x <- c(1, 2, 3, 4, 5)
num_bins <- 3
discretizeEF(x, num_bins)
```

## 2.3. Discretización general

La función `discretize` te permite discretizar valores de atributo en función de puntos de corte personalizados. Recibe como entrada un vector de valores numéricos y un vector de puntos de corte.

```{r}
# Ejemplo de uso
x <- c(1, 2, 3, 4, 5)
cut_points <- c(2, 4)
discretize(x, cut_points)
```

## 2.4. Discretización de atributos en un conjunto de datos

La función `discretize_attribute` discretiza un único atributo en un conjunto de datos. Puedes especificar el método de discretización (ancho igual, frecuencia igual o general) y el número de intervalos o los puntos de corte personalizados.

```{r}
# Ejemplo de uso - Discretización de ancho igual
data <- discretize_attribute(data, "attribute_name", method = "equal_width", num_bins = 3)

# Ejemplo de uso - Discretización de frecuencia igual
data <- discretize_attribute(data, "attribute_name", method = "equal_frequency", num_bins = 3)

# Ejemplo de uso - Discretización general
cut_points <- c(2, 4)
data <- discretize_attribute(data, "attribute_name", method = "custom", cut_points = cut_points)
```

# 3. Métricas
El script `metrics.R` incluye funciones relacionadas con la entropía, la varianza y el cálculo del área bajo la curva ROC (AUC).

## 3.1. Cálculo de la entropía

La función `calculate_entropy` calcula la entropía de un atributo discreto. Recibe como entrada un vector de valores de atributo y devuelve el valor de entropía.

```{r cálculo-de-entropía}
valores_del_atributo <- c("A", "B", "A", "C", "B")
calculate_entropy(valores_del_atributo)
```

## 3.2. Cálculo de la varianza

La función `calculate_variance` calcula la varianza de un atributo continuo. Recibe como entrada un vector de valores de atributo y devuelve el valor de varianza.

```{r cálculo-de-varianza}
valores_del_atributo <- c(1, 2, 3, 4, 5)
calculate_variance(valores_del_atributo)
```

## 3.3. Cálculo del AUC

La función `calculate_auc` calcula el área bajo la curva ROC (AUC) de un atributo continuo con respecto a las etiquetas de clase. Recibe como entrada vectores de valores de atributo y etiquetas de clase, y devuelve una lista que contiene los valores de tasa de verdaderos positivos (TPR), tasa de falsos positivos (FPR) y el valor del AUC.

```{r cálculo-del-auc}
valores_del_atributo <- c(1, 2, 3, 4, 5)
etiquetas_de_clase <- c(0, 1, 1, 0, 1)
calculate_auc(valores_del_atributo, etiquetas_de_clase)
```

El paquete también proporciona funciones para calcular métricas específicas de atributos para un determinado conjunto de datos.

## 3.4. Entropía del atributo

La función `calculate_attribute_entropy` calcula la entropía de un atributo específico en el conjunto de datos.

```{r ejemplo-de-entropía-del-atributo}
conjunto_de_datos <- data.frame(A = c(1, 2, 3, 4, 5), B = c("A", "B", "A", "B", "A"))
calculate_attribute_entropy(conjunto_de_datos, "B")
```

## 3.5. Varianza del atributo

La función `calculate_attribute_variance` calcula la varianza de un atributo específico en el conjunto de datos.

```{r ejemplo-de-varianza-del-atributo}
conjunto_de_datos <- data.frame(A = c(1, 2, 3, 4, 5), B = c(2.5, 4.5, 6.5, 8.5, 10.5))
calculate_attribute_variance(conjunto_de_datos, "B")
```

## 3.6. AUC del atributo

La función `calculate_attribute_auc` calcula el AUC de un atributo específico en el conjunto de datos en relación con el atributo de clase.

```{r ejemplo-de-auc-del-atributo}
conjunto_de_datos <- data.frame(A = c(1, 2, 3, 4, 5), B = c(2.5, 4.5, 6.5, 8.5, 10.5), Clase = c(0, 1, 1, 0, 1))
calculate_attribute_auc(conjunto_de_datos, "B", "Clase")
```

# 4. Preprocesamiento

El módulo `preprocessing.R` proporciona funciones para tareas comunes de preprocesamiento, como normalización y estandarización de variables.

## 4.1. Normalización Min-Max

La función `normalize_variable` normaliza una variable numérica utilizando la normalización min-max. Recibe como entrada un vector o matriz de valores numéricos y devuelve un vector con los valores normalizados.

```{r normalización-min-max}
x <- c(1, 2, 3, 4, 5)
normalize_variable(x)
```

## 4.2. Estandarización Z-Score

La función `standardize_variable` estandariza una variable numérica utilizando la estandarización z-score. Recibe como entrada un vector o matriz de valores numéricos y devuelve un vector con los valores estandarizados.

```{r estandarización-z-score}
x <- c(1, 2, 3, 4, 5)
standardize_variable(x)
```

## 4.3. Normalización del conjunto de datos

La función `normalize_dataset` normaliza todas las variables numéricas en un conjunto de datos. Recibe como entrada un conjunto de datos (marco de datos o similar) y devuelve un nuevo conjunto de datos con las variables numéricas normalizadas.

```{r normalización-del-conjunto-de-datos}
conjunto_de_datos <- data.frame(A = c(1, 2, 3, 4, 5), B = c(0.1, 0.2, 0.3, 0.4, 0.5))
normalize_dataset(conjunto_de_datos)
```

## 4.4. Estandarización del conjunto de datos

La función `standardize_dataset` estandariza todas las variables numéricas en un conjunto de datos. Recibe como entrada un conjunto de datos (marco de datos o similar) y devuelve un nuevo conjunto de datos con las variables numéricas estandarizadas.

```{r estandarización-del-conjunto-de-datos}
conjunto_de_datos <- data.frame(A = c(1, 2, 3, 4, 5), B = c(10, 20, 30, 40, 50))
standardize_dataset(conjunto_de_datos)
```

# 5. Filtrado

El módulo `Filtering.R` proporciona funciones para filtrar las variables de un conjunto de datos en función de diferentes métricas y criterios de umbral.

## 5.1. Filtrado de variables

La función `filter_variables` filtra las variables del conjunto de datos en función de la métrica, el umbral y los criterios de operador especificados. Recibe como entrada un conjunto de datos (marco de datos), una métrica (carácter), un umbral (numérico), un operador (carácter) y un nombre de atributo de clase opcional (carácter) para el cálculo del AUC. Devuelve un nuevo marco de datos que contiene las variables filtradas.

```{r Filtrado}
conjunto_de_datos <- data.frame(A = c(1, 2, 3, 4, 5), B = c(2.5, 4.5, 6.5, 8.5, 10.5), Clase = c(0, 1, 1, 0, 1))
filter_variables(conjunto_de_datos, "varianza", 5, ">")
```

# 6. Correlación

El script `correlation.R` contiene funciones para calcular la correlación entre variables numéricas y la información mutua entre variables categóricas.

## 6.1. Cálculo de la correlación

La función `calculate_correlation` calcula la correlación entre dos variables en un conjunto de datos. Recibe como entrada un conjunto de datos (marco de datos o similar), el nombre de la primera variable y el nombre de la segunda variable. Devuelve el coeficiente de correlación entre las dos variables.

```{r calcular-correlación}
conjunto_de_datos <- data.frame(A = c(1, 2, 3, 4, 5), B = c(0.1, 0.2, 0.3, 0.4, 0.5))
calculate_correlation(conjunto_de_datos, "A", "B")
```

## 6.2. Cálculo de la matriz de correlación

La función `calculate_correlation_matrix` calcula la correlación (o información mutua para variables categóricas) en pares entre las variables del conjunto de datos. Recibe como entrada un conjunto de datos (marco de datos o similar) y devuelve un marco de datos que contiene la matriz de correlación.

```{r calcular-matriz-de-correlación}
conjunto_de_datos <- data.frame(A = c(1, 2, 3, 4, 5), B = c(0.1, 0.2, 0.3, 0.4, 0.5))
calculate_correlation_matrix(conjunto_de_datos)
```

# 7. Visualización

El script `visualization.R` proporciona funciones para visualizar métricas utilizando la biblioteca **ggplot2**.

## 7.1. Gráfico de entropía

La función `plot_entropy` crea un gráfico de barras de los valores de entropía para cada atributo. Recibe como entrada los valores de entropía y los nombres de los atributos y genera un gráfico.

```{r gráfico-de-entropía}
valores_de_entropía <- c(0.5, 0.7, 0.2, 0.9)
nombres_de_atributos <- c("A", "B", "C", "D")
plot_entropy(valores_de_entropía, nombres_de_atributos)
```

## 7.2. Gráfico de varianza

La función `plot_variance` crea un gráfico de barras de los valores de varianza para cada atributo. Recibe como entrada los valores de varianza y los nombres de los atributos y genera un gráfico.

```{r gráfico-de-varianza}
valores_de_varianza <- c(0.5, 0.7, 0.2, 0.9)
nombres_de_atributos <- c("A", "B", "C", "D")
plot_variance(valores_de_varianza, nombres_de_atributos)
```

## 7.3. Gráfico de AUC

La función `plot_auc` crea un gráfico de

 barras de los valores de AUC para cada atributo. Recibe como entrada los valores de AUC y los nombres de los atributos y genera un gráfico.

```{r gráfico-de-auc}
valores_de_auc <- c(0.5, 0.7, 0.2, 0.9)
nombres_de_atributos <- c("A", "B", "C", "D")
plot_auc(valores_de_auc, nombres_de_atributos)
```

## 7.4. Gráfico de la Matriz de Correlación

La función `plot_correlation_matrix` crea un gráfico de mapa de calor de la matriz de correlación. Recibe como entrada una matriz de correlación y genera un gráfico.

```{r gráfico-de-matriz-de-correlación}
matriz_de_correlación <- matrix(c(1, 0.8, 0.4, 0.8, 1, 0.6, 0.4, 0.6, 1), nrow = 3)
plot_correlation_matrix(matriz_de_correlación)
```

## 7.5. Gráfico de ROC AUC

La función `plot_roc_auc` crea un gráfico de la curva ROC y el valor AUC correspondiente para un atributo dado y un atributo de clase en un conjunto de datos. Recibe como entrada un conjunto de datos, el nombre del atributo y el nombre del atributo de clase, y genera el gráfico.

```{r gráfico-de-roc-auc}
conjunto_de_datos <- data.frame(Atributo = c(1, 2, 3, 4, 5), Clase = c(0, 1, 1, 0, 1))
atributo <- "Atributo"
atributo_de_clase <- "Clase"
plot_roc_auc(conjunto_de_datos, atributo, atributo_de_clase)
```
