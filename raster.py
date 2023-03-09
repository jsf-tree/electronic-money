import gdal

# specify the path to the .img file
img_path = r'R:\IMAGENS_MAXAR_MOSAICADAS\MAXAR21\050036660220_01\21jan13125626-s2as_050036660220_01_p001.img'

# open the .img file using GDAL
img_dataset = gdal.Open(img_path)

# check that the dataset was opened successfully
if img_dataset is None:
    print("Could not open file:", img_path)
else:
    # get the number of bands in the dataset
    num_bands = img_dataset.RasterCount
    print("Number of bands:", num_bands)

    # loop through each band and print the band number and data type
    for i in range(1, num_bands + 1):
        band = img_dataset.GetRasterBand(i)
        print("Band", i, "data type:", gdal.GetDataTypeName(band.DataType))