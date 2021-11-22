Laboratorio 8
================

# Feature Engineering

``` r
library(dplyr)
library(gensvm)
data <- read.csv("titanic.csv")
data_MD <- read.csv("titanic_MD.csv")
```

## **Parte 1**

### 1. Reporte detallado de missing data para todas las columnas. (5%)

``` r
summary(data_MD)
```

    ##   PassengerId       Survived          Pclass          Name          
    ##  Min.   :  2.0   Min.   :0.0000   Min.   :1.000   Length:183        
    ##  1st Qu.:263.5   1st Qu.:0.0000   1st Qu.:1.000   Class :character  
    ##  Median :457.0   Median :1.0000   Median :1.000   Mode  :character  
    ##  Mean   :455.4   Mean   :0.6721   Mean   :1.191                     
    ##  3rd Qu.:676.0   3rd Qu.:1.0000   3rd Qu.:1.000                     
    ##  Max.   :890.0   Max.   :1.0000   Max.   :3.000                     
    ##                                                                     
    ##      Sex                 Age            SibSp            Parch      
    ##  Length:183         Min.   : 0.92   Min.   :0.0000   Min.   :0.000  
    ##  Class :character   1st Qu.:24.00   1st Qu.:0.0000   1st Qu.:0.000  
    ##  Mode  :character   Median :35.50   Median :0.0000   Median :0.000  
    ##                     Mean   :35.69   Mean   :0.4611   Mean   :0.462  
    ##                     3rd Qu.:48.00   3rd Qu.:1.0000   3rd Qu.:1.000  
    ##                     Max.   :80.00   Max.   :3.0000   Max.   :4.000  
    ##                     NA's   :25      NA's   :3        NA's   :12     
    ##     Ticket               Fare           Cabin             Embarked        
    ##  Length:183         Min.   :  0.00   Length:183         Length:183        
    ##  Class :character   1st Qu.: 29.70   Class :character   Class :character  
    ##  Mode  :character   Median : 56.93   Mode  :character   Mode  :character  
    ##                     Mean   : 78.96                                        
    ##                     3rd Qu.: 90.54                                        
    ##                     Max.   :512.33                                        
    ##                     NA's   :8

Viendo el contenido de las columnas vemos que hay columnas categoricas
que están como numericas. El primer paso antes de detallar los valores
faltantes será corregir las columnas a su debido tipo de datos.

``` r
data_MD <- data_MD %>% mutate(Survived = factor(Survived),
                              Pclass = factor(Pclass),
                              Sex = factor(Sex),
                              SibSp = factor(SibSp),
                              Parch = factor(Parch),
                              Embarked = factor(Embarked)) %>% 
  select(-PassengerId, -Name)
summary(data_MD)
```

    ##  Survived Pclass      Sex          Age         SibSp      Parch    
    ##  0: 60    1:158   ?     :51   Min.   : 0.92   0   :109   0   :116  
    ##  1:123    2: 15   female:64   1st Qu.:24.00   1   : 62   1   : 33  
    ##           3: 10   male  :68   Median :35.50   2   :  6   2   : 21  
    ##                               Mean   :35.69   3   :  3   4   :  1  
    ##                               3rd Qu.:48.00   NA's:  3   NA's: 12  
    ##                               Max.   :80.00                        
    ##                               NA's   :25                           
    ##     Ticket               Fare           Cabin           Embarked
    ##  Length:183         Min.   :  0.00   Length:183          : 12   
    ##  Class :character   1st Qu.: 29.70   Class :character   C: 59   
    ##  Mode  :character   Median : 56.93   Mode  :character   Q:  2   
    ##                     Mean   : 78.96                      S:110   
    ##                     3rd Qu.: 90.54                              
    ##                     Max.   :512.33                              
    ##                     NA's   :8

-   **Sex:** 51 observaciones faltantes (?)
-   **Age:** 25 observaciones faltantes (NA’s)
-   **SibSp:** 3 observaciones faltantes (NA’s)
-   **Parch:** 12 observaciones faltantes (NA’s)
-   **Fare:** 8 observaciones faltantes (NA’s)
-   **Embarked:** 12 observaciones faltantes (’ ’)

### 2. Para cada columna especificar qué tipo de modelo se utilizará (solo el nombre y el porqué) y qué valores se le darán a todos los missing values. (Ej. Imputación sectorizada por la moda, bins, y cualquier otro método visto anteriormente). (10%)

-   Para la variable `Sex` se utilizará un modelo de regresión
    logística, pues el 28% de las observaciones no tienen sexo
    especificado, y llenar los faltantes con la moda sesgaría mucho la
    variable.
-   Para `Age` se utilizará una imputación por la mediana, pues la
    distribución de la variable es normal con un poco de sesgo positivo.
    Utilizando la media para las 25 observaciones faltantes evitará que
    se sesgue más la distribución.
-   Para `SibSp` (número de hermanos/pareja abordo) se utilizará una
    imputación por la moda, pues es una variable que la estamos tratando
    como categórica, y además, solo son 3 observaciones faltantes
    de 183.
-   Para `Parch` (número de hijos/padres abordo) se utilizará igualmente
    una imputación por la moda, pues es variable categórica y la razón
    de valores faltantes es igualmente baja (6.5%), por lo que no sesga
    la distribución demasiado.
-   Para `Fare` se utilizará una imputación por la mediana, debido a que
    es una distribución altamente sesgada por valores atípicos. La
    mediana evitará que los valores imputados no sean sesgados por los
    atípicos.
-   Para `Embarked` se utilizará una imputación por la moda, pues es
    categórica y los valores faltantes representan un 6.5% de las
    observaciones.

### 3. Reporte de qué filas están completas (5%)

-   **Survived** *0: No y 1: Si*
-   **Pclass** *Clase en que viajaba*
-   **Ticket** *Número de ticket*
-   **Cabin** *Número de cabina*

Las columnas de ID y nombre del pasajero también están completas pero no
son relevantes para el análisis.

### 4. Utilizar los siguientes métodos para cada columna que contiene missing values: (50%)

1.  Imputación general (media, moda y mediana)
2.  Modelo de regresión lineal
3.  Outliers: Uno de los dos métodos vistos en clase (Standard deviation
    approach o Percentile approach)

#### Sex

``` r
# Imputacion por moda
Sex_mode <- ifelse(data_MD$Sex=='?', 
                   yes = '3',
                   no = data_MD$Sex)
table(Sex_mode)
```

    ## Sex_mode
    ##   2   3 
    ##  64 119

``` r
# Modelo de regresion
data_for_regression <- data_MD %>% filter(Sex!='?') %>% 
  select(Survived,Pclass,Age,Fare,Embarked,Sex) %>% 
  na.omit()

linreg_sex <- glm(formula = Sex~.,
                  data = data_for_regression, family = binomial)
new_data <- data_MD[data_MD$Sex=='?',]
probabilities <- linreg_sex %>% predict(new_data, type="response")
predicted_sex <- ifelse(probabilities>0.5,"female","male")
table(predicted_sex)
```

    ## predicted_sex
    ## female   male 
    ##     12     27

#### Age

``` r
# Imputacion por media
Age_mean <- ifelse(is.na(data_MD$Age),
                   yes = mean(data_MD$Age, na.rm = T),
                   no = data_MD$Age)
# Imputacion por mediana
Age_median <- ifelse(is.na(data_MD$Age),
                   yes = median(data_MD$Age, na.rm = T),
                   no = data_MD$Age)
# Regresion lineal
linreg_age <- lm(Age~Survived+Pclass+Sex+SibSp+Parch+Fare+Embarked,
                 data = data_MD)
Age_linreg <- predict(linreg_age, data_MD)
# Outliers - Percentile aproach
percentiles <- quantile(data_MD$Age,na.rm = T)
Age_outliers <- ifelse(data_MD$Age>percentiles[5],
                       yes = percentiles[5],
                       no = data_MD$Age)
```

#### SibSp

``` r
# Imputacion por moda
SibSp_mode <- ifelse(is.na(data_MD$SibSp), 
                   yes = '0',
                   no = data_MD$SibSp)
```

#### Parch

``` r
# Imputacion por moda
Parch_mode <- ifelse(is.na(data_MD$Parch), 
                   yes = '0',
                   no = data_MD$Parch)
```

#### Fare

``` r
# Imputacion por media
Fare_mean <- ifelse(is.na(data_MD$Fare),
                   yes = mean(data_MD$Fare, na.rm = T),
                   no = data_MD$Fare)
# Imputacion por mediana
Fare_median <- ifelse(is.na(data_MD$Fare),
                   yes = median(data_MD$Fare, na.rm = T),
                   no = data_MD$Fare)
# Regresion lineal
linreg_fare <- lm(Fare~Survived+Pclass+Sex+SibSp+Parch+Age+Embarked,
                 data = data_MD)
Fare_linreg <- predict(linreg_fare, data_MD)
# Outliers - Percentile aproach
percentiles <- quantile(data_MD$Fare,na.rm = T)
Fare_outliers <- ifelse(data_MD$Fare>percentiles[5],
                       yes = percentiles[5],
                       no = data_MD$Fare)
```

#### Embarked

``` r
# Imputacion por moda
Embarked_mode <- ifelse(data_MD$Embarked=='', 
                   yes = '0',
                   no = data_MD$Embarked)
```

### 5. Al comparar los métodos del inciso 4 contra “titanic.csv”, ¿Qué método (para cada columna) se acerca más a la realidad y por qué? (20%)

``` r
# Llenando los datos de las columnas de data_MD
data_MD$Age <- ifelse(is.na(data_MD$Age),
                   yes = median(data_MD$Age, na.rm = T),
                   no = data_MD$Age)
data_MD$SibSp <- ifelse(is.na(data_MD$SibSp), 
                   yes = '0',
                   no = data_MD$SibSp)
data_MD$Parch <- ifelse(is.na(data_MD$Parch), 
                   yes = '0',
                   no = data_MD$Parch)
data_MD$Fare <- ifelse(is.na(data_MD$Fare),
                   yes = median(data_MD$Fare, na.rm = T),
                   no = data_MD$Fare)
data_MD$Embarked <- ifelse(data_MD$Embarked=='', 
                   yes = '0',
                   no = data_MD$Embarked)

data_for_regression <- data_MD %>% filter(Sex!='?') %>% 
  select(Survived,Pclass,Age,SibSp,Parch,Fare,Embarked,Sex)
linreg_sex <- glm(formula = Sex~.,
                  data = data_for_regression, family = binomial)
new_data <- data_MD[data_MD$Sex=='?',]
```

comparando con `titanic.csv`:

``` r
summary(data$Age)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.92   24.00   36.00   35.67   47.50   80.00

``` r
summary(data_MD$Age)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.92   25.00   35.50   35.67   46.50   80.00

``` r
summary(data$Fare)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   29.70   57.00   78.68   90.00  512.33

``` r
summary(data_MD$Fare)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   30.00   56.93   78.00   90.00  512.33

Las variables numericas se acoplan bastante bien a la data original. La
imputación por la media sirvió para que no se sesguen las variables.

### 6. Conclusiones (10%)

Lo primero para tratar missing values es asegurarse que todas las
variables estén en el tipo de dato que corresponden, si hay variables
categoricas que aparecen como numericas hay que codificarlas con la
función `factor()` y luego hacer una tabla para ver cuantas
observaciones tiene cada categoría. Para las variables numéricas hay que
ver a qué distribución se acoplan para decidir qué tipo de imputación se
utilizará, pues si la distribución es muy sesgada, una imputación por la
media no será la adecuada y podrá darnos resultados alejados de la
realidad.

## **Parte 2**

### 1. Luego del pre-procesamiento de la data con Missing Values, normalice las columnas numéricas por los métodos: (50%)

1.  Standarization
2.  MinMaxScaling
3.  MaxAbsScaler

``` r
# Standaization
Age_st <- (data_MD$Age - mean(data_MD$Age))/sd(data_MD$Age)
Fare_st <- (data_MD$Fare - mean(data_MD$Fare))/sd(data_MD$Fare)

# MinMax Scaling
Age_minmax <- (data_MD$Age - min(data_MD$Age))/(max(data_MD$Age)-min(data_MD$Age))
Fare_minmax <- (data_MD$Fare - min(data_MD$Fare))/(max(data_MD$Fare)-min(data_MD$Fare))

# MaxAbs Scaling
Age_maxabs <- data_MD$Age/max(abs(data_MD$Age))
Fare_maxabs <- data_MD$Fare/max(abs(data_MD$Fare))
```

### 2. Compare los estadísticos que considere más importantes para su conclusión y compare contra la data completa de “titanic.csv” (deberán de normalizar también). (50%)

``` r
## Age
# Standarization
Age_st2 <- (data$Age - mean(data$Age))/sd(data$Age)
summary(Age_st)
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -2.39182 -0.73423 -0.01144  0.00000  0.74576  3.05180

``` r
summary(Age_st2)
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -2.22160 -0.74626  0.02081  0.00000  0.75592  2.83342

``` r
# Normalization
Age_minmax2 <- (data$Age - min(data$Age))/(max(data$Age)-min(data$Age))
summary(Age_minmax)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0000  0.3045  0.4373  0.4394  0.5764  1.0000

``` r
summary(Age_minmax2)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0000  0.2919  0.4436  0.4395  0.5890  1.0000

``` r
# MaxAbs Scale
Age_maxabs2 <- data$Age/max(abs(data$Age))
summary(Age_maxabs)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0115  0.3125  0.4437  0.4458  0.5813  1.0000

``` r
summary(Age_maxabs2)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0115  0.3000  0.4500  0.4459  0.5938  1.0000

``` r
## Fare
# Standarization
Fare_st2 <- (data$Fare - mean(data$Fare))/sd(data$Fare)
summary(Fare_st)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## -1.0337 -0.6361 -0.2792  0.0000  0.1591  5.7566

``` r
summary(Fare_st2)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## -1.0306 -0.6416 -0.2840  0.0000  0.1482  5.6799

``` r
# Normalization
Fare_minmax2 <- (data$Fare - min(data$Fare))/(max(data$Fare)-min(data$Fare))
summary(Fare_minmax)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## 0.00000 0.05856 0.11112 0.15224 0.17567 1.00000

``` r
summary(Fare_minmax2)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## 0.00000 0.05797 0.11126 0.15358 0.17567 1.00000

``` r
# MaxAbs Scale
Fare_maxabs2 <- data$Fare/max(abs(data$Fare))
summary(Fare_maxabs)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## 0.00000 0.05856 0.11112 0.15224 0.17567 1.00000

``` r
summary(Fare_maxabs2)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## 0.00000 0.05797 0.11126 0.15358 0.17567 1.00000
