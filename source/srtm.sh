#!/bin/bash

#NASA Shuttle Radar Topography Mission Global 3 arc second V003
#https://search.earthdata.nasa.gov/

#read settings
source ../config.sh

cd ../data/SRTM

# unzip
unzip -o '*.zip'


# convert hgt to geotiff
for i in *.hgt
do
  gdal_translate -r bilinear $i "${i}.hgt.tif"
done

# merge tiles
gdalbuildvrt mosaic.vrt *.tif
gdal_translate -co COMPRESS=LZW -co PREDICTOR=2 -co TILED=YES -r bilinear  mosaic.vrt srtm.tif

# reproject
gdalwarp -s_srs EPSG:4326 \
		-t_srs EPSG:2100 \
		-tr $RESOLUTION $RESOLUTION \
		-te $Xmin $Ymin $Xmax $Ymax \
		-r bilinear \
		-overwrite \
		-of GTiff srtm.tif srtm_2100.tif

# hillshade
gdaldem hillshade -az 45 -z 1.3  srtm_2100.tif srtm_hillshade_2100.tif

gdaldem slope -p srtm_2100.tif srtm_2100_slope.tif

#normalize slope
zMin=`gdalinfo -mm ./srtm_2100_slope.tif | sed -ne 's/.*Computed Min\/Max=//p'| tr -d ' ' | cut -d "," -f 1`
zMax=`gdalinfo -mm ./srtm_2100_slope.tif | sed -ne 's/.*Computed Min\/Max=//p'| tr -d ' ' | cut -d "," -f 2`

#zMin=`gdalinfo -stats ./srtm_2100_slope.tif | sed -ne 's/.*STATISTICS_MINIMUM=//p'`
#zMax=`gdalinfo -stats ./srtm_2100_slope.tif | sed -ne 's/.*STATISTICS_MAXIMUM=//p'`

echo Min:$zMin
echo Max:$zMax 


#gdal_calc.py -A srtm_2100_slope.tif --outfile=srtm_2100_slope_norm.tif --calc="100*((A-$zMin)/($zMax-$zMin))"
gdal_calc.py -A srtm_2100_slope.tif --outfile=srtm_2100_slope_norm.tif --calc="(100*A)/${zMax}" --NoDataValue=-32768

gdal_translate -of VRT srtm_hillshade_2100.tif srtm_hillshade_2100.vrt -a_nodata none # convert NODATA VALUE to NaN
gdal_calc.py -A  srtm_hillshade_2100.vrt --outfile=srtm_hillshade_2100_tmp.tif --calc="nan_to_num(A)" #Replace NaN with zero, https://docs.scipy.org/doc/numpy/reference/generated/numpy.nan_to_num.html
gdal_calc.py -A srtm_hillshade_2100_tmp.tif --overwrite --outfile=srtm_hillshade_2100_tmp2.tif --calc="181*equal(A,0)+A*not_equal(A,0)"



# export to gif
gdal_translate -of GIF srtm_2100_slope_norm.tif roi.slope.gif
gdal_translate -of GIF srtm_hillshade_2100_tmp2.tif roi.hillshade.gif

cp *.gif ../../output
cp *.xml ../../output
rm *.gif
rm *.xml
rm *.vrt

# clean up
rm -f *.hgt.tif mosaic.vrt srtm.tif srtm_2100.tif srtm_hillshade_2100.tif *.tif *.hgt
