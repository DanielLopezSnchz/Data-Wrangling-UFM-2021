Inversiones en Energía, S.A.
================

## Sumario de la investigación

Este reporte tiene como objetivo entender, por medio de los datos
brindados, cómo funcionó el periodo del 2017 para la empresa Inversiones
en Energía, S.A. y de esta manera utilizar estos hallazgos para mejorar
la estrategia de las operaciones futuras. Se presentará primero un
Estado de Resultados breve del 2017 y luego se procederá a entender, por
medio del comportamiento en volumen de servicios, tipo de servicios,
recorridos, unidades de transporte y costos, qué fue lo que hizo que
este año fuera tan exitoso; al igual que cosas que se pueden mejorar.

## Entendiendo los datos

El dataset que se utilizó para este reporte contiene 14 variables:

-   ID: *código de identificación del poste al que se le dió el
    servicio*
-   Cod: *Tipo de servicio que se brindó. Ej. Revisión, Cambio
    correctivo, etc.*
-   origen: *La identificación de cada centro de distribución (4 en
    total)*
-   factura: *Valor de la factura en Q. (Precio de venta del servicio)*
-   height: *Altura del poste*
-   Tipo.unidad: *Se refiere a unidad de transporte (Moto, Pickup o
    Camión)*
-   Distancia\_min: *Distancia recorrida. Intervalos de tiempo en mins*
-   Ingreso: *factura - Costo*

``` r
str(data)
```

    ## 'data.frame':    263725 obs. of  14 variables:
    ##  $ Fecha        : Date, format: "2017-01-16" "2017-06-14" ...
    ##  $ ID           : int  767918 386136 588199 658299 860501 662960 515998 515998 918251 627621 ...
    ##  $ Cod          : Factor w/ 10 levels "CAMBIO_CORRECTIVO",..: 6 5 7 10 10 6 5 5 10 10 ...
    ##  $ origen       : Factor w/ 4 levels "150224","150277",..: 2 1 1 2 2 2 2 1 2 2 ...
    ##  $ Lat          : num  14.8 15.5 14.3 14.3 15.4 ...
    ##  $ Long         : num  -89.3 -90.2 -90.9 -89.7 -89.2 ...
    ##  $ factura      : num  79.3 101.7 118.9 75.7 81.3 ...
    ##  $ height       : Factor w/ 5 levels "8","10","12",..: 3 3 4 1 2 1 1 1 2 2 ...
    ##  $ Tipo.unidad  : Factor w/ 3 levels "Camion_5","Pickup",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Costo        : num  40.4 34.7 52.9 53.7 46.3 ...
    ##  $ cto_directo  : num  24.6 20.8 32.8 34.4 31 ...
    ##  $ cto_fijo     : num  15.7 13.9 20.1 19.4 15.3 ...
    ##  $ Distancia_min: Factor w/ 5 levels "120-","30-45",..: 4 4 4 4 4 4 4 4 4 4 ...
    ##  $ Ingreso      : num  39 67 66 22 35 49 70 40 48 31 ...
    ##  - attr(*, "na.action")= 'omit' Named int [1:1054900] 1 2 3 4 5 6 7 8 9 10 ...
    ##   ..- attr(*, "names")= chr [1:1054900] "1" "2" "3" "4" ...

## Análisis de la situación

### Estado de resultados

    ## Ingresos Totales    36688096 
    ##  Costo Directo       17893607 
    ##  Costo Fijo          10280412 
    ##  Utilidad Operativa  8514077 
    ##  Margen Operativo    23 %

### ¿Cómo se comportó la utilidad operativa mensual a lo largo del año?

Esta gráfica de línea muestra la estacionalidad de las utilidades
operativas. En primera instancea vemos una gran caída en febrero, y una
recuperación en marzo.
![](Reporte-Lab-7_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Existen 4 centros de distribución en la empresa. Vemos en ésta gráfica
las utilidades operativas de cada uno. Hay una diferencia sustancial con
las primeras dos y las ultimas dos.
![](Reporte-Lab-7_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

También podemos ver que la caída en febrero se dió simultáneamente en
los 4 centros de distribución. De hecho, las utilidades mensuales
durante todo el año variaron de igual manera para los cuatro centros.

En esta grafica se visualiza la cantidad de servicios promedio que se
brinda desde cada centro de distribución. Podemos ver de forma más clara
que los últimos dos no tienen mayor demanda.

    ## `summarise()` has grouped output by 'origen'. You can override using the `.groups` argument.

![](Reporte-Lab-7_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

#### ¿A qué se debe esta correlación en utilidades operativas de los 4 centros de distribución?

Si analizamos las áreas en donde opera cada centro de distribución
(origen) podemos notar que práticamente las locaciones en donde cada uno
brinda servicios son las mismas. Este mapa muestra la región en donde
cada centro opera. Cada circulo es un centro de distribución y su radio
está determinado por la cantidad de servicios anuales.

``` r
### Mapa de areas en que opera cada centro de distribucion
coordenadas <- data %>% 
  group_by(origen) %>% 
  summarise(Lat = mean(Lat),
            Long = mean(Long),
            Cantidad = n()) %>% 
  mutate(Peso = Cantidad/nrow(data)*100)

leaflet(coordenadas) %>% addTiles() %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1,
             radius = ~Peso * 100, popup = ~origen
  )
```

![Mapa Centros de Distribucion](Mapa.png) Las utilidades operativas
mensuales se ven afectadas de la misma manera en los cuatro centros de
distribución porque la caída en la demanda de servicios de esta región
representa una caída en las utilidades de los cuatro centros. Es por
esto que mi recomendación es que se trasladen las operaciones de los dos
centros de distribución con menor demanda de servicios (150278 y 150841)
a otra región. Esto les permitirá estar más diversificados en cuanto a
sus locaciones y que las utilidades operativas de la empresa no dependan
de la demanda de solo una región.

### Análisis de servicios facturados y utilidades

Ahora analicemos la cantidad en Q. que se factura por recorrido. El
recorrido está dado por 5 intervalos que representan la distancia en
minutos que se tarda la unidad de transporte en llegar al poste para
darle el servicio necesario.

    ## `summarise()` has grouped output by 'Distancia_min'. You can override using the `.groups` argument.

![](Reporte-Lab-7_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Vemos que, por mucho, la mayor cantidad de facturación se hace por
servicios a 75-120 minutos de distancia. Ahora veamos si este orden de
montos facturados por recorrido prevalece si se hace la misma gráfica
pero en vez de la facturación, se analizan las utilidades.

![](Reporte-Lab-7_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

El mayor monto de utilidades sigue siendo de los servicios brindados a
75-120 minutos de distancia, pero vemos que el segundo recorrido que más
factura (120 minutos o más) es el que menos utilidades representa para
la empresa. De igual manera, el recorrido de 45-75 brinda menos
utilidades en proporcion a lo que factura.

Para ver qué esta pasando con las utilidades por recorrido debemos
analizar los costos de dicho recorrido. Para esto vamos a tomar en
cuenta también el tipo de unidad de transporte que se usa. De inmediato
podemos notar que el recorrido con mayor costo promedio es el de la
distancia de 120 minutos o más. También podemos ver que el costo
promedio de hacer un viaje de 120 mins o más con camión es mayor al
costo promedio de hacer el mismo viaje con pickup o moto. Esto no es
igual a los demás recorridos, pues el costo promedio de cada recorrido
es muy similar entre los tipos de unidad de transporte.

    ## `summarise()` has grouped output by 'Tipo.unidad'. You can override using the `.groups` argument.

![](Reporte-Lab-7_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

Ahora regresemos a analizar más a detalle la facturación. Para el
recorrido de 120+ mins vemos que lo que más se factura son servicios los
cuales se hacen, en su mayoría, con camiones; los cuales tienen un costo
promedio mayor.
![](Reporte-Lab-7_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

La estrategia que propongo con base a este hallazgo es que se traten de
minimizar los viajes con camión en los recorridos de 120 minutos o más,
reemplazandolos por viajes con pickups, que tienen un menor costo
promedio. Lo ideal sería que se hagan más en moto, pero es entendible
que la moto solo se trate de utilizar para recorridos más cortos, por su
limitada capacidad de carga de equipo necesario para las reparaciones,
revisiones, etc.

### Información adicional

#### Análisis de Pareto (80/20)

![](Reporte-Lab-7_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

Como información adicional, los servicios que representaron el 80% de
las utilidades fueron los primeros 5 de la gráfica, con una
predominancia de las revisiones.
