#!/bin/bash

cd ../data/OLS;
echo $PWD;
for i in *.tif
do
	YEAR=$(basename $i .tif)
	echo $YEAR
	gdal_calc.py -A $i -B ../../output/roi.excluded.gif --overwrite  --NoDataValue=256 --outfile="masked_OLS_${i}" --calc="0*equal(B,100) | A*equal(B,1)" 
	gdal_translate -of GIF "masked_OLS_${i}" "roi.urban.${YEAR}.gif"
	
	cp roi.urban.*.gif ../../output
	cp *.xml ../../output

	rm -f "masked_OLS_${i}"
	rm roi.urban.*.gif
	rm *.xml
done


#rm *.tif
