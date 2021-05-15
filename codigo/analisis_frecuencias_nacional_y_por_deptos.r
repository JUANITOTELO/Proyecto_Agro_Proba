# -*- coding: utf-8 -*-

# install.packages('plyr')

 #Instalación y cargado de la librería necesaria para hacer el conteo 
 #de frecuencias de variable categórica
 library(plyr)
 library(ggplot2)

# Frecuencia de afectaciones a nivel nacional a lo largo del tiempo (sin discriminar por años)


 cultivos <- read.table("../cultivos_nacional_filtrado.csv", sep=",", header=TRUE)
 cultivos <- subset(cultivos, select=c("P_S6P60"))
 cultivos = data.frame(cultivos)
# head(cultivos)


 fenomenos_cod_nombre <- read.table("../codigo_fenomenos.csv", sep=",", header=TRUE)
 fenomenos_cod_nombre  = data.frame(fenomenos_cod_nombre)
# fenomenos_cod_nombre


 frecuencias_afectaciones = count(cultivos, "P_S6P60")
 #ordenar por frecuencias de forma descendente
 frecuencias_afectaciones = frecuencias_afectaciones[order(-frecuencias_afectaciones$freq),]
 
 #quitar la fila de mayor frecuencia porque esta corresponde
 #a los cultivos que no fueron afectados
 frecuencias_afectaciones = frecuencias_afectaciones[-c(1), ]
# frecuencias_afectaciones

 #se hace un join entre las frecuencias de cada código del fenómeno 
 #y el nombre real del fenómeno para ponerse de una mejor forma en 
 #el diagrama de barras
 
 fenom_freqs = merge(x = frecuencias_afectaciones, y = fenomenos_cod_nombre, by = "P_S6P60")
 #quita la columna llamada "P_S6P60"
 fenom_freqs = fenom_freqs[-c(1)]
# fenom_freqs


 pdf(file="frecuencia_de_fenom_que_afect_cultivos_nacional.pdf") 
 p <- ggplot(data=fenom_freqs, aes(x=fenomeno, y=freq, fill=freq)) + geom_bar(stat="identity", color="black") + coord_flip() 
 p <- p + labs(title="Frecuencia de fenómenos que afectan cultivo (nivel nacional) ", x="Fenómeno", y = "Cantidad de cultivos afectados")
 p  + theme_minimal()

# Frecuencia Relativa de Afectaciones a Nivel General por Departamento
#
#----
#*ej: poder decir para cada qué porcentaje de los cultivos son damnificados*


 cultivos_dep <- read.table("../cultivos_nacional_filtrado.csv", sep=",", header=TRUE)
 cultivos_dep <- subset(cultivos_dep, select=c("P_DEPTO", "P_S6P60"))
 cultivos_dep = data.frame(cultivos_dep)
# head(cultivos_dep)

 #cultivos de departamento que no se han visto afectados por
 #ningún fenómeno
 cultivos_dep_sanos <- cultivos_dep[cultivos_dep$P_S6P60 == 12, ] 
# head(cultivos_dep_sanos)

 #cultivos de departamento que se han visto afectados por fenómenos listados 
 frecuencias_no_afectaciones_dep = count(cultivos_dep_sanos, "P_DEPTO")

 #ordenar por frecuencias de forma descendente
 frecuencias_no_afectaciones_dep = frecuencias_no_afectaciones_dep[order(-frecuencias_no_afectaciones_dep$freq),]
 frecuencias_no_afectaciones_dep <- rename(frecuencias_no_afectaciones_dep, replace = c("freq" = "freq_no_afect"))
 
# frecuencias_no_afectaciones_dep


 #obtiene los cultivos afectados
 cultivos_dep_afect <- cultivos_dep[cultivos_dep$P_S6P60 != 12, ] 
 head(cultivos_dep_afect)

 frecuencias_afectaciones_dep = count(cultivos_dep_afect, "P_DEPTO")
 #ordenar por frecuencias de forma descendente
 frecuencias_afectaciones_dep = frecuencias_afectaciones_dep[order(-frecuencias_afectaciones_dep$freq),]
 
# frecuencias_afectaciones_dep


 fenom_freqs_relatv = merge(x = frecuencias_afectaciones_dep, y = frecuencias_no_afectaciones_dep, by = "P_DEPTO")
 #quita la columna llamada "P_S6P60"
# fenom_freqs_relatv

 porcentaje_afect = 100*(fenom_freqs_relatv[,2] / (fenom_freqs_relatv[,2] + fenom_freqs_relatv[,3]))  
 fenom_freqs_relatv <- cbind(fenom_freqs_relatv, "porcentaje_afect" = porcentaje_afect)
 fenom_freqs_relatv <- subset(fenom_freqs_relatv, select=c("P_DEPTO", "porcentaje_afect"))
# fenom_freqs_relatv

 dept_name <- read.table("../codigo_depto_a_nombre.csv", sep=",", header=TRUE)
 dept_name = data.frame(dept_name)
# head(dept_name)

 porcentajes_depto = merge(x = dept_name, y = fenom_freqs_relatv, by = "P_DEPTO")
 
 #quita la columna llamada "P_DEPTO"
 porcentajes_depto = porcentajes_depto[-c(1)]
 porcentajes_depto = porcentajes_depto[order(-porcentajes_depto$porcentaje_afect),]
# porcentajes_depto

 pdf(file="porcentaje_cultivos_afectados_por_dpto.pdf") 
 p <- ggplot(data=porcentajes_depto, aes(x=Nombre.del.departamento, y=porcentaje_afect, fill=porcentaje_afect))
 p <-p + geom_bar(stat="identity", color="black") + coord_flip()
 p <- p + labs(title="Porcentaje de cultivos afectados por dpto.", x="Departamento", y = "Porcentaje de cultivos afectados")
 p  + theme_minimal()


# Frecuencia Absoluta de Afectaciones a Nivel General por Departamento
#
#----
#*ej: poder decir para cada departamento cuantos cultivos son damnificados*
#

 #se hace un join entre las frecuencias de cada código del fenómeno 
 #y el nombre real del fenómeno para ponerse de una mejor forma en 
 #el diagrama de barras
 

 
 fenom_freqs_depto = merge(x = frecuencias_afectaciones_dep, y = dept_name, by = "P_DEPTO")
 #quita la columna llamada "P_S6P60"
 fenom_freqs_depto = fenom_freqs_depto[-c(1)]
 
# fenom_freqs_depto

 pdf(file="cantidad_cultivos_afectados_por_dpto.pdf") 
 p <- ggplot(data=fenom_freqs_depto, aes(x=Nombre.del.departamento, y=freq, fill=freq)) + geom_bar(stat="identity", color="black") + coord_flip()
 p <- p + labs(title="Cantidad de cultivos afectados por dpto.", x="Departamento", y = "Cantidad de cultivos afectados")
 p  + theme_minimal()

# Diagrama de torta de afectaciones

 dept_name_choco = dept_name[(dept_name$Nombre.del.departamento == "Chocó"),]
 dept_name_san_andres = dept_name[(dept_name$Nombre.del.departamento == "Archipiélago de San Andrés, Providencia y Santa Catalina"),]
 
# print(dept_name_san_andres)
# print(dept_name_choco)

 cultivos_san_andres = cultivos_dep[cultivos_dep$P_DEPTO == 88,]
 cultivos_choco = cultivos_dep[cultivos_dep$P_DEPTO == 27 ,]

 print(cultivos_san_andres[1:6,])
 print(cultivos_choco[1:6,])

 frecuencias_afectaciones_isla = count(cultivos_san_andres, "P_S6P60")
 frecuencias_afectaciones_cho = count(cultivos_choco, "P_S6P60")
 
 #ordenar por frecuencias de forma descendente
 frecuencias_afectaciones_isla = frecuencias_afectaciones_isla[order(-frecuencias_afectaciones_isla$freq),]
 frecuencias_afectaciones_cho = frecuencias_afectaciones_cho[order(-frecuencias_afectaciones_cho$freq),]
 
 #quitar la fila de mayor frecuencia porque esta corresponde
 #a los cultivos que no fueron afectados
 frecuencias_afectaciones_isla = frecuencias_afectaciones_isla[-c(1), ]
 frecuencias_afectaciones_cho = frecuencias_afectaciones_cho[-c(1), ]
 
# print(frecuencias_afectaciones_isla)
# print(frecuencias_afectaciones_cho)

 porcentajes_isla = 100*(frecuencias_afectaciones_isla[,2]/ sum(frecuencias_afectaciones_isla$freq))
 porcentajes_cho = 100*(frecuencias_afectaciones_cho[,2]/ sum(frecuencias_afectaciones_cho$freq))
 
 df_porcentajes_isla <- cbind(frecuencias_afectaciones_isla, "porcentaje_afect" = porcentajes_isla)
 df_porcentajes_isla <- subset(df_porcentajes_isla, select=c("P_S6P60", "porcentaje_afect"))
 
 
 df_porcentajes_cho <- cbind(frecuencias_afectaciones_cho, "porcentaje_afect" = porcentajes_cho)
 df_porcentajes_cho <- subset(df_porcentajes_cho, select=c("P_S6P60", "porcentaje_afect"))
 
# df_porcentajes_cho

 df_porcentajes_cho = merge(x = df_porcentajes_cho, y = fenomenos_cod_nombre, by = "P_S6P60")
 df_porcentajes_isla = merge(x = df_porcentajes_isla, y = fenomenos_cod_nombre, by = "P_S6P60")
 
 df_porcentajes_isla = subset(df_porcentajes_isla, select=c("fenomeno", "porcentaje_afect"))
 df_porcentajes_cho = subset(df_porcentajes_cho, select=c("fenomeno", "porcentaje_afect"))

# df_porcentajes_cho
# df_porcentajes_isla[,2]

 pdf(file="pie_de_afect_isla.pdf") 
 pie(df_porcentajes_isla[,2], labels= paste0(round(df_porcentajes_isla[,2],1),"%" ),
     main = "Distribución de afectaciones Archipiélago de San Andrés,\n Providencia y Santa Catalina",
     col = rainbow(length(df_porcentajes_isla[,2])))
 legend("left", df_porcentajes_isla[,1] , cex = 0.8, fill = rainbow(length(df_porcentajes_isla[,2])))

 pdf(file="porcentaje_de_afect_choco.pdf") 
 p <- ggplot(df_porcentajes_cho, aes(x=fenomeno, y=df_porcentajes_cho[,2], fill=df_porcentajes_cho[,2])) + 
       geom_bar(stat="identity", color="black") + coord_flip() +
       geom_text(aes(label=paste0(round(df_porcentajes_cho[,2],1), "%")), vjust=0.5, color="blue", size=4)
 p <- p + labs(title="Porcentaje de afectaciones Chocó.", x="Fenómeno", y = "Porcentaje")
     
 p  + theme_minimal()+ theme(legend.position = "none")

## Documentación usada
#----
#1. https://www.rdocumentation.org/packages/plyr/versions/1.8.6/topics/count (función count usada para hacer el trabajo de conteo de frecuencias de variable categórica). Instalación de la librería: https://www.rdocumentation.org/packages/plyr/versions/1.8.6 
#2. Para ordenar un df: https://www.programmingr.com/examples/r-dataframe/sort-r-data-frame/ 
#3. Intercambiar el orden de dos columnas de un dataframe: https://www.statology.org/switch-two-columns-in-r/ 
#4. Documentación de diagrama de barras: https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/barplot
#5. Selección de filas de forma útil y práctica: https://statisticsglobe.com/filter-data-frame-rows-by-logical-condition-in-r 
#6. hacer suma de frecuencias en un dataframe: https://statisticsglobe.com/get-sum-of-data-frame-column-values-in-r 
#7. quitar leyenda de ggplot: https://statisticsglobe.com/remove-legend-ggplot2-r 
#
#----
#
#Material de referencia útil
#1. https://www.programmingr.com/statistics/how-to-plot-categorical-data-in-r/ 
#2. ggplots: http://www.sthda.com/english/wiki/ggplot2-barplots-quick-start-guide-r-software-and-data-visualization 
#
