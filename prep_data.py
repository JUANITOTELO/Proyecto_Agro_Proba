import zipfile
import pandas as pd

#Extracción del zip del archivo cultivos_nacional.zip 
#para el filtrado de datos
zfile = "./documentos/cultivos_nacional.zip"

try: 
    with zipfile.ZipFile(zfile) as z:
        z.extractall("./documentos/")
        print("Extracción exitosa del archivo '{}'".format(zfile))

except:
        print("Extracción fallida del archivo '{}'".format(zfile))


#lectura del archivo csv filtrando solo por 
#las columnas que nos son de interés
df = pd.read_csv("./documentos/cultivos_nacional.csv", usecols = ["P_S6P46", "P_S6P47B","P_DEPTO","P_S6P59_UNIF","P_S6P60","AREA_SEMBRADA","AREA_COSECHADA"])
start_len = len(df)

#borrado de los datos que tienen un NaN en la
#columna que indica la razón que afectó al cultivo 
df.dropna(subset=["P_S6P60"], inplace=True)
no_nan_len = len(df)
delta1 = start_len - no_nan_len

#resete de los índices y no intente guardarlos en el dataframe
df.reset_index(drop=True, inplace=True)

#obtiene un subdataframe con todos los datos inconsistentes
inconsistent_df = df.loc[ (df["P_S6P60"] == 12) & (df["AREA_COSECHADA"]==0) ]

#borra los basándose en los índices del dataframe que contiene 
#data inconsistente
df.drop(labels = inconsistent_df.index.values, axis=0, inplace=True)
df.reset_index(drop=True, inplace=True)

consistent_data_len = len(df)

print("***"*40)
print(df.head(5))
print("---"*40)
print("cantidad de datos iniciales: {:d}\ndatos eliminados con el filtro de NaN: {:d}".format(start_len,delta1))
print("cantidad de datos despues de borrar los NaN: {:d}".format(no_nan_len))
print("cantidad de datos inconsistentes borrados: {:d}".format(no_nan_len - consistent_data_len))
print("cantidad de datos sobrantes: {:d}".format(consistent_data_len))
print("---"*40)
print("\n")


print(df.head(5))

df.to_csv("./documentos/cultivos_nacional_filtrado.csv", index=False)

#documentación usada:
#1) https://www.statology.org/drop-na-pandas/
#2) https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.dropna.html
#3) https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.reset_index.html
#4) https://appdividend.com/2020/04/28/python-how-to-select-rows-from-pandas-dataframe/
#5) https://www.shanelynn.ie/pandas-drop-delete-dataframe-rows-columns/



