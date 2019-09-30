#!/bin/bash

source ../config.sh

# 1. First clip it and reproject it:

work_dir=$PWD
echo $work_dir

cd "../data/corine";
unzip -o '*.zip'

corine(){
	cd $work_dir;
	echo $work_dir;
	cd $1;
	echo $PWD;


	gdalwarp -s_srs EPSG:3035 \
		 	-t_srs EPSG:2100 \
		 	-tr $RESOLUTION $RESOLUTION \
		 	-te $Xmin $Ymin $Xmax $Ymax \
			-overwrite \
			-of GTiff `ls CLC*.tif` tmp_clipped.tif




	# set any class to No Data
	#gdal_translate tmp_clipped.tif tmp1.tif -a_nodata 111



	# 2. Reclassify:

	#gdal_calc.py -A tmp_clipped.tif --outfile=tmp1.tif --calc="A*not_equal(A,111)  &  A*not_equal(A,523) &  A*not_equal(A,212)"

	#gdal_calc.py -A tmp1.tif --outfile=tmp0.tif --calc="A*not_equal(A,-32767)" --NoDataValue=0

	gdal_calc.py -A tmp_clipped.tif --outfile=tmp1.tif --calc="1*logical_and(A>=100,A<200)+ 2*logical_and(A>=200,A<300) + 3*logical_and(A>=300,A<400) + 4*logical_and(A>=400,A<500) +5*logical_and(A>=500,A<600)" --NoDataValue=0 #set nodata value


	gdal_translate -of VRT tmp1.tif tmp_raster.vrt -a_nodata none # convert NODATA VALUE to NaN

	gdal_calc.py -A  tmp_raster.vrt --outfile=tmp.tif --calc="nan_to_num(A)" #Replace NaN with zero, https://docs.scipy.org/doc/numpy/reference/generated/numpy.nan_to_num.html

	gdal_calc.py -A tmp.tif --overwrite --outfile=tmp1_1.tif --calc="5*equal(A,0)+A*not_equal(A,0)"

	gdal_calc.py -A tmp1_1.tif --overwrite --outfile=tmp3.tif --calc="100*equal(A,4)  |  100*equal(A,5)"

	#gdal_translate tmp1.tif tmp2.tif -a_nodata 4 
	#gdal_translate tmp2.tif tmp2.tif -a_nodata 5



	#set 0 to NoData
	#gdal_translate tmp2.tif tmp3.tif -a_nodata 0


	#export to gif
	gdal_translate -of GIF tmp1_1.tif "roi.landuse.${2}.gif"
	gdal_translate -of GIF tmp3.tif "roi.excluded.${2}.gif"

	# copy to FINAL DATA
	cp "roi.landuse.${2}.gif" ../../../output
	cp "roi.landuse.${2}.gif.aux.xml" ../../../output
	cp "roi.excluded.${2}.gif" ../../../output
	cp "roi.excluded.${2}.gif.aux.xml" ../../../output

	#remove tmp
	rm -rf *tmp*.tif *clipped.tif
}

corine "../data/corine/clc2000_clc1990_v2018_20_raster100m" "1992"
corine "../data/corine/clc2006_clc2000_v2018_20_raster100m" "2000"
corine "../data/corine/clc2012_clc2006_v2018_20_raster100m" "2006"
corine "../data/corine/clc2018_clc2012_v2018_20_raster100m" "2012"
