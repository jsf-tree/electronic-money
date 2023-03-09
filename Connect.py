import arcpy

out_folder_path = r'C:\Users\juliano.finck\Documents\ArcGIS\Projects\MyProject'
out_name = 'ceperj_iderj_not_m.sde'
database_platform = 'POSTGRESQL'
instance = '51.124.235.0,5432'
account_authentication = 'DATABASE_AUTH'
username = 'sde'
password = 'sde22R@'
save_user_pass = 'SAVE_USERNAME'
database = 'gisdb'
version_type = 'TRANSACTIONAL'

arcpy.CreateDatabaseConnection_management(out_folder_path, out_name, database_platform, instance, account_authentication, username, password, save_user_pass, database, version_type)

#a = arcpy.ArcSDESQLExecute(server='51.124.235.0', instance='5432', database='gisdb', user='sde', password='sde22R@')
