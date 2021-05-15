library(dplyr)
library(tidyverse)
library(ggplot2)
install.packages("ggpubr")
library(ggpubr)
# Se carga la tabla original y se guarda en la varible mydata
mydata <- read.table("../cultivos_nacional.csv", header=TRUE, sep=",");

# Se organizan los datos de menor a mayor por anios
mydata = mydata %>% arrange(P_S6P47B)

# Se calculan la media y desviacion estandar por anios del area
# sembrada y cosechada
medias_ds_por_a = mydata %>% 
group_by(P_S6P47B) %>%
summarise(media_area_sembrada = mean(AREA_SEMBRADA), ds_area_sembrada = sd(AREA_SEMBRADA),
          media_area_cosechada = mean(AREA_COSECHADA), ds_area_cosechada = sd(AREA_COSECHADA))

# Se hacen las graficas que muestran la desviacion y la media de cada area
# y se guardan en un pdf
pdf(file="media-ds-area-sembrada-cosechada-smooth.pdf", width=9, height=12)
mdss = ggplot(medias_ds_por_a[4:67,], aes(x=P_S6P47B, y=media_area_sembrada, color=ds_area_sembrada))+labs(color="Desviación Estándar\n",x = "Año", y = "Media de área Sembrada (Ha)", title = "Media y Desviación Estándar del Área Sembrada")+geom_smooth()+geom_point( size = 5, alpha = 1/3)+scale_color_gradient(low = "green", high = "red", na.value = NA)
mdsc = ggplot(medias_ds_por_a[4:67,], aes(x=P_S6P47B, y=media_area_cosechada, color=ds_area_cosechada))+labs(color="Desviación Estándar\n",x = "Año", y = "Media de área Cosechada (Ha)", title = "Media y Desviación Estándar del Área Cosechada")+geom_smooth()+geom_point( size = 5, alpha = 1/3)+scale_color_gradient(low = "green", high = "red", na.value = NA)
ggarrange(mdss, mdsc, ncol = 1, nrow = 2)