Laboratorio 6
================

``` r
library(stringr)
```

### Pregunta 1: 1. Genere una expresión regular que sea capaz de detectar las placas de un vehículo particular guatemalteco.

``` r
placas <- c('A123SAM', 'P516DJH','P216FMV','W650FAT','P492GZC')
patron <- str_detect(placas, '^[P]{1}[0-9]{3}(?![AEIOUÑ])[A-Z]{3}$')
placas[patron==1]
```

    ## [1] "P516DJH" "P216FMV" "P492GZC"

### Pregunta 2: Genere una expresión regular que valide si un archivo es de tipo .pdf o jpg.

``` r
archivos <- c('Ejemplo1.pdf', 'LAB06.rmd', 'data.csv', 'Grafica2.jpg')
patron <- grepl(pattern = "[.](jpg|JPG|pdf|PDF)$", x = archivos)
archivos[patron==1]
```

    ## [1] "Ejemplo1.pdf" "Grafica2.jpg"

### Pregunta 3: Genere una expresión regular para validar contraseñas de correo. Una contraseña de correo debe contener por lo menos 8 caracteres, una letra mayúscula y un carácter especial

``` r
pswds <- c('daniellopez$1978', 'DataWrangling%%2000', 'Contraseña', 'DanielLopezSnchz&23')
patron <- str_detect(pattern = '^(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$', 
                       string = pswds)
resultado <- ifelse(test = patron==1, yes = 'Contrasenia valida', no = 'Contrasenia invalida')

x <- rbind(pswds, resultado); rownames(x) <- c("Contrasenia", "Output")
x
```

    ##             [,1]                   [,2]                  [,3]                  
    ## Contrasenia "daniellopez$1978"     "DataWrangling%%2000" "Contraseña"          
    ## Output      "Contrasenia invalida" "Contrasenia valida"  "Contrasenia invalida"
    ##             [,4]                 
    ## Contrasenia "DanielLopezSnchz&23"
    ## Output      "Contrasenia valida"

### Pregunta 5: Cree una expresión regular que encuentre todas las palabras de la primera línea, pero ninguna de la segunda.

-   pit, spot, spate, slap two, respite
-   pt, Pot, peat, part

``` r
palabras <- c('pit', 'spot', 'spate', 'slap two', 'respite',
              'pt', 'Pot', 'peat', 'part')
patron <- grepl(pattern = '.*p.t.*', x = palabras)
palabras[patron==1]
```

    ## [1] "pit"      "spot"     "spate"    "slap two" "respite"

### Pregunta 7: Genere una expresión regular que sea capaz de obtener correos de la UFM.

``` r
correos <- c('daniellopez@ufm.edu', 'daniel.lopez@datagysolutions.com', 'dl.dany2000@gmail.com')
patron <- grepl(x = correos,pattern =  '[A-Za-z]+@[ufm]+.(edu)$')
correos[patron==1]
```

    ## [1] "daniellopez@ufm.edu"

### Pregunta 8: En el mundo distópico de Eurasia, Big Brother le asigna un identificador único a cada ciudadano. Genere una expresión regular que valide las identificaciones. Composición del id:

-   El id inicia con 0 a 3 letras minúsculas (puede tener 0 letras
    minúsculas hasta tres letras minúsculas)
-   Luego es seguido por una cadena de dígitos que puede ser de 2 a 9
    dígitos respectivamente.
-   Inmediatamente después de la cadena de dígitos, se encuentra por lo
    menos tres letras mayúsculas.
-   Ej: abc012333ABCDEEEE

``` r
id <- c('abc012333ABCDEEEE', 'jei239790ASUC', '5252765GYHSc', '67jhGTDU0H')
str_detect(id,'^[a-z]{0,3}[0-9]{2,9}[A-Z]{2,}')
```

    ## [1]  TRUE  TRUE  TRUE FALSE
