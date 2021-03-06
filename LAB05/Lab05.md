Laboratiorio 5
================

    ## Warning: package 'nycflights13' was built under R version 4.1.1

## Parte 1: Predecir un eclipse solar

En tiempo de Norte América, el eclipse total inició el 21 de agosto del
2017 a las 18:26:40. Este mismo evento, sucederá un Saros después. Un
Saros equivale a 223 Synodic Months Un Synodic Month equivale a 29 días
con 12 horas, con 44 minutos y 3 segundos.

Con esta información, predecir el siguiente eclipse solar.

Requisitos:

-   Variable con la fecha del eclipse histórico.
-   Variable que sea un Saros.
-   Variable que sea un Synodic Month.
-   La fecha del siguiente eclipse solar

``` r
eclipse_hist <- dmy_hms('21-08-2017 18:26:40')
Synodic_month <- ddays(29) + dhours(12) + dminutes(44) + dseconds(3)
Saros <- 223*Synodic_month
proximo_eclipse <- eclipse_hist + Saros
paste0('proximo eclipse total:', proximo_eclipse, ' UTC')
```

    ## [1] "proximo eclipse total:2035-09-02 02:09:49 UTC"

## Parte 2: Agrupaciones y operaciones con fechas

Utilizando la data adjunta “data.xlsx” y el paquete “Lubridate”,
responda a las siguientes preguntas:

1.  ¿En qué meses existe una mayor cantidad de llamadas por código?

``` r
data$mes <- month(data$fecha_creacion)
por.mes <- data %>% group_by(mes, Cod) %>% 
  summarise(llamadas = n())
```

    ## `summarise()` has grouped output by 'mes'. You can override using the `.groups` argument.

``` r
por.mes <- split(x = por.mes, f = por.mes$Cod)
por.mes <- lapply(por.mes, function(df) {df[order(df$llamadas, decreasing = T),]})
por.mes[[1]][1,]
```

    ## # A tibble: 1 x 3
    ## # Groups:   mes [1]
    ##     mes Cod   llamadas
    ##   <dbl> <chr>    <int>
    ## 1     7 0         1471

``` r
por.mes[[2]][1,]
```

    ## # A tibble: 1 x 3
    ## # Groups:   mes [1]
    ##     mes Cod                          llamadas
    ##   <dbl> <chr>                           <int>
    ## 1     5 Actualización de Información     1679

``` r
por.mes[[3]][1,]
```

    ## # A tibble: 1 x 3
    ## # Groups:   mes [1]
    ##     mes Cod           llamadas
    ##   <dbl> <chr>            <int>
    ## 1     7 Cancelaciones     4132

``` r
por.mes[[4]][1,]
```

    ## # A tibble: 1 x 3
    ## # Groups:   mes [1]
    ##     mes Cod    llamadas
    ##   <dbl> <chr>     <int>
    ## 1     3 Cobros      698

``` r
por.mes[[5]][1,]
```

    ## # A tibble: 1 x 3
    ## # Groups:   mes [1]
    ##     mes Cod       llamadas
    ##   <dbl> <chr>        <int>
    ## 1    10 Consultas    10890

``` r
por.mes[[6]][1,]
```

    ## # A tibble: 1 x 3
    ## # Groups:   mes [1]
    ##     mes Cod         llamadas
    ##   <dbl> <chr>          <int>
    ## 1     3 Empresarial     3108

``` r
por.mes[[7]][1,]
```

    ## # A tibble: 1 x 3
    ## # Groups:   mes [1]
    ##     mes Cod          llamadas
    ##   <dbl> <chr>           <int>
    ## 1     9 Otros/Varios     1116

2.  ¿Qué día de la semana es el más ocupado?

``` r
data$dia <- day(data$fecha_creacion)
por.dia <- data %>% group_by(dia) %>% summarise(llamadas=n())
por.dia[order(por.dia$llamadas, decreasing = T),][1,]
```

    ## # A tibble: 1 x 2
    ##     dia llamadas
    ##   <int>    <int>
    ## 1     3     8895

3.  ¿Qué mes es el más ocupado?

``` r
mensual <- data %>% group_by(mes) %>% summarise(llamadas=n())
mensual[order(mensual$llamadas, decreasing = T),][1,]
```

    ## # A tibble: 1 x 2
    ##     mes llamadas
    ##   <dbl>    <int>
    ## 1    10    22681

4.  ¿Existe una concentración o estacionalidad en la cantidad de
    llamadas?

``` r
g1 <- ggplot(data = mensual, mapping = aes(x=mes, y = llamadas))+
  geom_line()
g1
```

![](Lab05_files/figure-gfm/unnamed-chunk-7-1.png)<!-- --> La cantidad de
llamadas tiene repuntes en marzo, mayo, julio, octubre y diciembre. Si
hay estacionalidad.

5.  ¿Cuántos minutos dura la llamada promedio?

``` r
mean(data$duracion)
```

    ## Time difference of 14.88962 mins

6.  Realice una tabla de frecuencias con el tiempo de llamada.

## Parte 3: Signo Zodiacal

Realice una función que reciba como input su fecha de nacimiento y
devuelva como output su signo zodiacal.

``` r
signo_zodiacal <- function(fecha_nac){
  
  fecha <- dmy(fecha_nac)
  mes <- month(fecha_nac)
  dia <- day(fecha_nac)
  
  if (mes==1){
    signo <- ifelse(test = dia<20,
                    yes = 'capricornio',
                    no = 'acuario')
  } else if(mes==2){
    signo <- ifelse(test = dia<19,
                    yes = 'acuario',
                    no = 'piscis')
  } else if(mes==3){
    signo <- ifelse(test = dia<21,
                    yes = 'piscis',
                    no = 'aries')
  } else if(mes==4){
    signo <- ifelse(test = dia<20,
                    yes = 'aries',
                    no = 'tauro')
  } else if(mes==5){
    signo <- ifelse(test = dia<21,
                    yes = 'tauro',
                    no = 'geminis')
  } else if(mes==6){
    signo <- ifelse(test = dia<21,
                    yes = 'geminis',
                    no = 'cancer')
  } else if(mes==7){
    signo <- ifelse(test = dia<23,
                    yes = 'cancer',
                    no = 'leo')
  } else if(mes==8){
    signo <- ifelse(test = dia<23,
                    yes = 'leo',
                    no = 'virgo')
  } else if(mes==9){
    signo <- ifelse(test = dia<23,
                    yes = 'virgo',
                    no = 'libra')
  } else if(mes==10){
    signo <- ifelse(test = dia<23,
                    yes = 'libra',
                    no = 'escorpio')
  } else if(mes==11){
    signo <- ifelse(test = dia<22,
                    yes = 'escorpio',
                    no = 'sagitario')
  } else if(mes==12){
    signo <- ifelse(test = dia<22,
                    yes = 'sagitario',
                    no = 'capricornio')
  }
  
  return(signo)
  
}

signo_zodiacal('12-08-2000')
```

    ## [1] "leo"

## Parte 4: Flights

Utilizando la tabla de flights vista en clase, responda lo siguiente:

dep\_time, arr\_time, sched\_dep\_time,sched\_arr\_time son variables
que representan la hora de salida de los aviones. Sin embargo, están en
formato numérico. Es decir, si una de las observaciones tiene 845 en
sched\_dep\_time y 932 en sched\_arr\_time significa que tenia como hora
de salida las 8:45 y llegada las 9:32.

1.  Genere 4 nuevas columnas para cada variable con formato fecha y
    hora.

``` r
flights$dep_time_new <- format(strptime(sprintf('%04d', 
                                                flights$dep_time), 
                                        format = '%H%M'),
                               '%H:%M')
flights$arr_time_new <- format(strptime(sprintf('%04d', 
                                                flights$arr_time), 
                                        format = '%H%M'),
                               '%H:%M')
flights$sched_dep_time_new <- format(strptime(sprintf('%04d', 
                                                flights$sched_dep_time), 
                                        format = '%H%M'),
                               '%H:%M')
flights$sched_arr_time_new <- format(strptime(sprintf('%04d', 
                                                flights$sched_arr_time), 
                                        format = '%H%M'),
                               '%H:%M')
head(flights)
```

    ## # A tibble: 6 x 23
    ##    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
    ##   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
    ## 1  2013     1     1      517            515         2      830            819
    ## 2  2013     1     1      533            529         4      850            830
    ## 3  2013     1     1      542            540         2      923            850
    ## 4  2013     1     1      544            545        -1     1004           1022
    ## 5  2013     1     1      554            600        -6      812            837
    ## 6  2013     1     1      554            558        -4      740            728
    ## # ... with 15 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    ## #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    ## #   hour <dbl>, minute <dbl>, time_hour <dttm>, dep_time_new <chr>,
    ## #   arr_time_new <chr>, sched_dep_time_new <chr>, sched_arr_time_new <chr>

2.  Encuentre el delay total que existe en cada vuelo. El delay total se
    puede encontrar sumando el delay de la salida y el delay de la
    entrada.

``` r
flights$delay_total <- flights$dep_delay + flights$arr_delay
```
