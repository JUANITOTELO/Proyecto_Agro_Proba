library(dplyr)
library(tidyverse)
library(ggplot2)
install.packages("ggpubr")
library(ggpubr)

mydata <- read.table("cultivos_nacional.csv", header=TRUE, sep=",");
mydataf <- read.table("cultivos_nacional_filtrado.csv", header=TRUE, sep=",");

mydata = mydata %>% arrange(P_S6P47B)
print(mydata[1:10,c(12,22,23)])
mydataf = mydataf %>% arrange(P_S6P47B)
print(mydataf[1:10,c(1,4,5)])

medias_ds_por_a = mydata %>% 
group_by(P_S6P47B) %>%
summarise(media_area_sembrada = mean(AREA_SEMBRADA), ds_area_sembrada = sd(AREA_SEMBRADA),
          media_area_cosechada = mean(AREA_COSECHADA), ds_area_cosechada = sd(AREA_COSECHADA))

medias_ds_por_a_f = mydataf %>% 
group_by(P_S6P47B) %>%
summarise(media_area_sembrada_f = mean(AREA_SEMBRADA), ds_area_sembrada_f = sd(AREA_SEMBRADA),
          media_area_cosechada_f = mean(AREA_COSECHADA), ds_area_cosechada_f = sd(AREA_COSECHADA))

print("Original")
print(medias_ds_por_a[1:10,])
print("Filtrada")
print(medias_ds_por_a_f[1:10,])

tablas = merge(medias_ds_por_a, medias_ds_por_a_f)
diferencia_filtro = tablas %>%
summarise(anio = P_S6P47B,
          dif_media_sembrada = media_area_sembrada - media_area_sembrada_f,
          dif_ds_sembrada = ds_area_sembrada - ds_area_sembrada_f,
          dif_media_cosechada = media_area_cosechada - media_area_cosechada_f,
          dif_ds_cosechada = ds_area_cosechada - ds_area_cosechada_f)
print(diferencia_filtro)

valores_modificados = filter(diferencia_filtro, diferencia_filtro[,2:5] != 0)
disminucion_valores = filter(valores_modificados, valores_modificados[,2:5] > 0)
aumento_valores = filter(valores_modificados, valores_modificados[,2:5] < 0)
print("Valores que cambiaron despues del filtro:")
print(valores_modificados)
print(disminucion_valores)
print(aumento_valores)

pdf(file="dif-media-ds-area-sembrada-cosechada-smooth.pdf", width=9, height=16)
mdss = ggplot(diferencia_filtro[4:67,], aes(x=anio, y=dif_media_sembrada, color=dif_ds_sembrada))+labs(color="Diferencia Desviación Estándar\n",x = "Año", y = "Diferencia Media de área Sembrada (Ha)", title = "Diferencia Media y Desviación Estándar del Área Sembrada")+geom_point( size = 5, alpha = 1/2)+scale_color_gradient(low = "blue", high = "green", na.value = NA)
mdsc = ggplot(diferencia_filtro[4:67,], aes(x=anio, y=dif_media_cosechada, color=dif_ds_cosechada))+labs(color="Diferencia Desviación Estándar\n",x = "Año", y = "Diferencia Media de área Cosechada (Ha)", title = "Diferencia Media y Desviación Estándar del Área Cosechada")+geom_point( size = 5, alpha = 1/2)+scale_color_gradient(low = "blue", high = "green", na.value = NA)
ggarrange(mdss, mdsc, ncol = 1, nrow = 2)

