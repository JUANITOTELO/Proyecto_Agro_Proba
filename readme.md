# Proyecto de análisis de datos de cultivos dados en el 3er censo nacional agropecuario


Con este proyecto, nos planteamos conocer mejor la situación de colombia en cuanto a cultivos y los factores que los afectan a través de la información recogida por el DANE en los últimos años, buscamos responder cuales son los departamentos mas afectados con respecto a la cantidad de sus cultivos, y cuales cultivos se han visto mas perjudicados en todo el país.

----

## Guía de uso: 

1. Descomprima el archivo con los datos de cultivos nacionales *cultivos_nacional.zip*, y ejecute el script de python
*prep_data.py*, este script se encarga de hacer el preprocesamiento de datos necesario para el posterior análisis 
estadístico en R.

2. Dentro de la carpeta código se encuentran todos los códigos para correrse como un Rscript:

			Rscript ./codigo/nombre_del_script_de_análisis.r

## Estructura del repositorio: 

* Codigo\_depto\_a\_nombre.csv *(tabla que relaciona el código de un departamento con su nombre)*.
* Codigo\_fenomenos.csv *(relaciona el código numérico del fenómeno de afectación del cultivo, con el nombre de  esta afectación)*.
* Documentos contiene el comprimido 'cultivos\_nacional.zip' que contiene todos los datos de las afectaciones de cultivos a nivel nacional.
* Equivalencias\_cultivos\_code.csv *(csv que relaciona los nombres de los cultivos con su código numérico)*


