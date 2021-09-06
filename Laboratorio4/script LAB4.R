library(dplyr)
library(highcharter)
library(lubridate)
library(ggplot2)

df <- read.csv("tabla_completa.csv", sep = ";")

str(df)

df <- df %>% 
  mutate(UBICACION = as.factor(UBICACION),
         CLIENTE = as.factor(CLIENTE),
         PILOTO = as.factor(PILOTO),
         CREDITO = as.factor(CREDITO),
         UNIDAD = as.factor(UNIDAD),
         MES = as.factor(MES),
         ANIO = as.factor(ANIO))

levels(df$UNIDAD)[2] <- 'Camion Pequenio'

##### EXPLORACION DE DATOS #######

# Ingreso mensual
ingreso_mensual <- df %>% 
  group_by(ANIO, MES) %>% 
  filter(TIPO.DE.ENTREGA!='DEVOLUCION') %>% 
  summarise(FACTURACION = sum(Q))
View(ingreso_mensual)


ingreso_mensual %>% 
  hchart("column", hcaes(x = MES, y = FACTURACION)) %>% 
  hc_title(text = "<b>Facturacion mensual<b>") %>% 
  hc_subtitle(text = "<i>Se ve una caida en ingresos en los meses de marzo, junio y septiembre del 2017<i>")

# Ingreso por ubicacion
ingreso_por_ubicacion <- df %>% 
  group_by(ANIO, MES, UBICACION) %>%
  filter(TIPO.DE.ENTREGA!='DEVOLUCION') %>% 
  summarise(FACTURACION = sum(Q))
View(ingreso_por_ubicacion)

ingreso_por_ubicacion %>% 
  hchart('column', hcaes(x = MES, y = FACTURACION, group = UBICACION)) %>%
  hc_colors(c("#0073C2FF", "#EFC000FF")) %>% 
  hc_title(text = "<b>Facturacion por ubicacion<b>")


# Tiempo de credito
credito <- df %>% 
  group_by(ANIO, MES, CREDITO) %>%
  filter(TIPO.DE.ENTREGA!='DEVOLUCION') %>% 
  summarise(FACTURACION = sum(Q))
View(credito)

credito %>% 
  hchart('column', hcaes(x = MES, y = FACTURACION, group = CREDITO)) %>%
  hc_colors(c('green','blue','orange')) %>% 
  hc_title(text = "<b>Facturacion por dias de credito<b>")


## Proyeccion de entradas de efectivo
credito$MES <- as.numeric(credito$MES)
credito$MES.INGRESO <- ifelse(test = credito$CREDITO=='30', yes = credito$MES+1,
                              no = ifelse(test = credito$CREDITO=='60', yes = credito$MES+2,
                                          no = credito$MES+3))
proyeccion_caja <- credito %>% 
  filter(MES.INGRESO>3 & MES.INGRESO<=12) %>% 
  select(ANIO, MES.INGRESO, FACTURACION) %>% 
  group_by(ANIO, MES.INGRESO) %>% 
  summarise(INGRESO = sum(FACTURACION)) %>% 
  mutate(MES.INGRESO = as.factor(MES.INGRESO))


proyeccion_caja %>%
  hchart('column', hcaes(x = MES.INGRESO, y = INGRESO)) %>% 
  hc_title(text = "<b>Ingresos percibidos a caja<b>") %>% 
  hc_subtitle(text = "<i>Se registra una caida en ingresos en los meses de mayo y septiembre<i>")
  


# Vehiculos

vehiculos <- df %>% 
  group_by(UNIDAD) %>% 
  summarise(NO.VIAJES = n())

# Bar chart del numero de viajes

vehiculos %>%
  hchart('column', hcaes(x = UNIDAD, y = NO.VIAJES)) %>% 
  hc_title(text = "<b>No. de Viajes por tipo de unidad<b>") %>% 
  hc_subtitle(text = "<i>Los camiones tipo Panel podrian llegar a 400 viajes<i>")
  


# Pilotos

pilotos <- df %>% 
  group_by(PILOTO,UNIDAD) %>% 
  summarise(VIAJES = n())

pilotos %>% 
  hchart('column', hcaes(x = PILOTO, y = VIAJES, group = UNIDAD)) %>%
  hc_colors(c('green','blue','orange')) %>% 
  hc_title(text = "<b>No. de Viajes por piloto y tipo de unidad<b>")

pilotos2 <- pilotos %>% 
  group_by(PILOTO) %>% 
  summarise(VIAJES = sum(VIAJES))


ggplot(data = pilotos2, mapping = aes(x = reorder(PILOTO,-VIAJES), y = VIAJES)) + geom_bar(stat = 'identity', fill='blue') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust=1)) +
  geom_text(aes(label=VIAJES), vjust=1.6, color="white", size=3.5) +
  ggtitle("Total del viajes por piloto") + xlab("PILOTO")

## 20-80 de clientes

clientes <- df %>% 
  group_by(CLIENTE) %>% 
  filter(TIPO.DE.ENTREGA!='DEVOLUCION') %>% 
  summarise(FACTURADO = sum(Q))
clientes$PORCENTAJE <- 100*clientes$FACTURADO/sum(clientes$FACTURADO)

ggplot(data = clientes, mapping = aes(x = reorder(CLIENTE,-PORCENTAJE), y = PORCENTAJE)) + geom_bar(stat = 'identity',fill='pink')+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust=1)) +
  geom_text(aes(label=paste(round(PORCENTAJE,0),"%")), vjust=1.6, color="black", size=3.5)+
  scale_y_continuous(labels = function(x) paste0(x, "%"))+
  ggtitle("80/20 de Clientes", subtitle = "Porcentaje de ingresos al 11/2017") + xlab("CLIENTE")






