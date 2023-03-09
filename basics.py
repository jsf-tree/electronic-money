import arcpy
import inspect

# sql_exec = arcpy.ArcSDESQLExecute ({server}, {instance}, {database}, {user}, {password})


# arcpy.env has several environment settings to use and abuse
arcpy.env.workspace = fr'<a_path>'      # all operations will start from here
arcpy.env.scratchGDB                    # noqa This can be used for a temporary scract gdb and always exist in any Pro
arcpy.env.scratchFolder                 # noqa analogous, but a folder

# alternatively several env settings can be set at once
with arcpy.EnvManager(cellSize=10, extent='-16, 25, 44, 64'):
    # Code to be executed with the environments set
    pass

# https://pro.arcgis.com/en/pro-app/latest/arcpy/geoprocessing_and_python/using-environment-settings.htm


# Pandas - https://youtu.be/_gaAoJBMJ_Q
import pandas as pd # noqa
df = pd.read_csv('mens 100m.csv', sep=',')             # watch out the dtype; pandas cant guess all
df['Athlete_Uppercase'] = df['Athelete'].str.upper()   # also see: str.strip(), str.lower(), str.replace()
df.head()

df = df.query()         # column1 > 5 and colum2 < 3    # don't forget @var can access external variables.

# save large data in parquet/feather/pickle instead of .csv

# Python Notebook - Better to visualize steps
# "pip install jupyter", "cd to workdir", "jupyter notebook"
