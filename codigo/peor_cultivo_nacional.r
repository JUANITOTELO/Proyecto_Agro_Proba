library(dplyr)
library(tidyverse)
library(ggplot2)
#Leer tablas
cultivos_code2name <- read.table("/gdrive/MyDrive/Proyecto_Probabilidad/probabilidad/equivalencias_cultivos_code.csv", sep=",", header=TRUE)
regre <- read.table("/gdrive/MyDrive/Proyecto_Probabilidad/probabilidad/cultivos_nacional_filtrado.csv", sep=",", header=TRUE)
#Total del area sembrada desde 1920 hasta 2013 de cada cultivo_id
suma_areas_sembradas = regre %>%
group_by(P_S6P46) %>%
summarise(total_cultivado=sum(AREA_SEMBRADA))

df_suma_areas_sembradas = as.data.frame(suma_areas_sembradas)
df_suma_areas_sembradas = arrange(df_suma_areas_sembradas,desc(total_cultivado))
colnames(df_suma_areas_sembradas) <- c("cultivo_id", "total_cultivos")
df_suma_areas_sembradas = na.omit(df_suma_areas_sembradas)
df_merge_suma_areas_sembradas = filter(df_suma_areas_sembradas)
print(df_merge_suma_areas_sembradas[1:10,]) #------------------
#---------------------------------------------------------------------

# Total cultivos afectados
afectados = filter(regre,P_S6P60 != 12) #Elimina de la tabla los cultivos que no fueron afectados

# Calculo de el area perdida
# (le restamos al area sembrada el area cosechada, para encontrar cuanto se perdio en cada reporte)
diferencia_areas <- afectados %>%
summarise(afectacion = P_S6P60,cultivo_id = P_S6P46,res_area = AREA_SEMBRADA-AREA_COSECHADA)
# print(diferencia_areas[1:10,])

# Total de area perdida (desde 1920 hasta 2013) de cultivo_id
# (Sumamos todas las perdidas de la anterior tabla para encontrar el total de area perdida)
suma_diferencia_areas = diferencia_areas %>%
group_by(cultivo_id) %>%
summarise(total_afectado=sum(res_area))

df_suma_diferencia_areas = as.data.frame(suma_diferencia_areas)
df_suma_diferencia_areas = arrange(df_suma_diferencia_areas,desc(total_afectado))
df_suma_diferencia_areas = na.omit(df_suma_diferencia_areas)
print(df_suma_diferencia_areas[1:10,]) #------------------

# Union de tablas
u_tablas = merge(df_merge_suma_areas_sembradas, df_suma_diferencia_areas, by = "cultivo_id")
# print(u_tablas[1:10,])
porcentajes_cultivo_ids = u_tablas %>%
summarise(cultivo_id,porcentaje_afectado=round((total_afectado*100)/total_cultivos, digits=9))
porcentajes_cultivo_ids = arrange(porcentajes_cultivo_ids,desc(porcentaje_afectado))
print(porcentajes_cultivo_ids[1:10,]) #------------------

# Graficas
graf_sembradas = full_join(df_merge_suma_areas_sembradas, cultivos_code2name, by="cultivo_id")
graf_sembradas = na.omit(graf_sembradas)
print(graf_sembradas[1:10,])

graf_afectadas = full_join(df_suma_diferencia_areas, cultivos_code2name, by="cultivo_id")
graf_afectadas = na.omit(graf_afectadas)
print(graf_afectadas[1:10,])

graf_porcentajes = full_join(porcentajes_cultivo_ids, cultivos_code2name, by="cultivo_id")
graf_porcentajes = na.omit(graf_porcentajes)
print(graf_porcentajes[1:10,])