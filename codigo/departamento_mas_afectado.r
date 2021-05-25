library(dplyr)
library(tidyverse)
library(ggplot2)
#Leer tablas
cultivos_code2name <- read.table("/gdrive/MyDrive/Proyecto_Probabilidad/probabilidad/equivalencias_cultivos_code.csv", sep=",", header=TRUE)
regre <- read.table("/gdrive/MyDrive/Proyecto_Probabilidad/probabilidad/cultivos_nacional_filtrado.csv", sep=",", header=TRUE)
#Total del area sembrada desde 1920 hasta 2013 de cada departamento
suma_areas_sembradas = regre %>%
group_by(P_DEPTO) %>%
summarise(total_cultivado=sum(AREA_SEMBRADA))

df_suma_areas_sembradas = as.data.frame(suma_areas_sembradas)
df_suma_areas_sembradas = arrange(df_suma_areas_sembradas,desc(total_cultivado))
colnames(df_suma_areas_sembradas) <- c("departamento", "total_cultivos")
df_suma_areas_sembradas = na.omit(df_suma_areas_sembradas)
df_merge_suma_areas_sembradas = filter(df_suma_areas_sembradas, departamento != 63)
print(df_merge_suma_areas_sembradas)
#---------------------------------------------------------------------

# Total cultivos afectados
afectados = filter(regre,P_S6P60 != 12) #Elimina de la tabla los cultivos que no fueron afectados

# Calculo de el area perdida 
# (le restamos al area sembrada el area cosechada, para encontrar cuanto se perdio en cada reporte)
diferencia_areas <- afectados %>%
summarise(afectacion = P_S6P60,departamento = P_DEPTO,res_area = AREA_SEMBRADA-AREA_COSECHADA)
# print(diferencia_areas[1:10,])

# Total de area perdida (desde 1920 hasta 2013) de departamento 
# (Sumamos todas las perdidas de la anterior tabla para encontrar el total de area perdida)
suma_diferencia_areas = diferencia_areas %>%
group_by(departamento) %>%
summarise(total_afectado=sum(res_area))

df_suma_diferencia_areas = as.data.frame(suma_diferencia_areas)
df_suma_diferencia_areas = arrange(df_suma_diferencia_areas,desc(total_afectado))
df_suma_diferencia_areas = na.omit(df_suma_diferencia_areas)
print(df_suma_diferencia_areas)

# Union de tablas
u_tablas = merge(df_merge_suma_areas_sembradas, df_suma_diferencia_areas, by = "departamento")
print(u_tablas)
porcentajes_departamentos = u_tablas %>%
summarise(departamento,porcentaje_afectado=round((total_afectado*100)/total_cultivos, digits=5))
print(arrange(porcentajes_departamentos,desc(porcentaje_afectado)))