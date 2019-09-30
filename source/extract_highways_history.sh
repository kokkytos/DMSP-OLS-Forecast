#!/bin/bash

#read settings
source ../config.sh
cd ../data/osm

## declare an array variable with years
declare -a  arr
arr=("2008" "2012")

FILE="clipped_greece_${osm_history_file}"


if test -f "$FILE"; then
	echo "$FILE exist"
else
	echo "$FILE does not exist"
	osmconvert $osm_history_file -b=19.23,34.45,29.07,42.10 -o=$FILE
fi

osm2gif(){

    YEAR=$1

    # extract until YEAR
    osmium time-filter $FILE --overwrite  "${YEAR}-12-31T00:00:00Z" -o "osm${YEAR}.pbf"

    # extract specific categories
    osmosis \
	    --read-pbf file="osm${YEAR}.pbf" \
	    --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential \
	    --used-node \
	    --write-pbf "osm${YEAR}_highways.pbf"

    # clip to roi
    osmconvert "osm${YEAR}_highways.pbf" -b=19.27,34.30,29.15,42.05 -o="osm${YEAR}_highways_roi.pbf"


    # convert to shapefile
    ogr2ogr -f "ESRI Shapefile"  -explodecollections -skipfailures -lco ENCODING=UTF-8 . "osm${YEAR}_highways_roi.pbf"


    # join with IDs
    ogr2ogr -sql "select lines.*,  cast(joincsv.ID AS INTEGER) from lines left join '../../source/joincsv.csv'.joincsv on lines.highway = joincsv.highway" "osm${YEAR}_highways_roi_join.shp" lines.shp

    # reproject to Greek Grid
    ogr2ogr -f "ESRI Shapefile"  -s_srs EPSG:4326 -t_srs EPSG:2100 "osm${YEAR}_highways_roi_join_2100.shp" "osm${YEAR}_highways_roi_join.shp" 

    #Delete dummy lines
    Rscript ../../source/filterOSMlines.R $YEAR $PWD

    # rasterize
    gdal_rasterize \
	    -l "lines_${YEAR}" \
	    -a joincsv_ID \
	    -tr $RESOLUTION $RESOLUTION \
	    -te $Xmin $Ymin $Xmax $Ymax \
	    -ot UInt32 \
	    -of GTiff "lines_${YEAR}.shp" "osm_${YEAR}_2100.tif"



    # tiff2gif
    gdal_translate -of GIF "osm_${YEAR}_2100.tif" "roi.roads.${YEAR}.gif"



    # clean up
    rm -f lines*.* multilinestrings*.* multipolygons*.* point*.* other_relations*.* 
    rm *.tif
    find . -type f -name "osm${YEAR}*.*" -exec rm -f {} +

    # copy to FINAL DATA		
    cp *.gif ../../output
    cp *.xml ../../output
	
    rm *.gif
    rm *.xml



}


## loop through the years
for i in "${arr[@]}"
do
   osm2gif "$i"
done

