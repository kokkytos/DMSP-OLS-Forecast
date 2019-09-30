cd ../data/corine;

gdal_calc.py \
-A ./clc2000_clc1990_v2018_20_raster100m/roi.excluded.1992.gif \
-B ./clc2006_clc2000_v2018_20_raster100m/roi.excluded.2000.gif \
-C ./clc2012_clc2006_v2018_20_raster100m/roi.excluded.2006.gif \
-D ./clc2018_clc2012_v2018_20_raster100m/roi.excluded.2012.gif \
--outfile=roi.excluded_tmp.tif \
--calc="A*equal(A,100)  | B* equal(B,100) | C*equal(C,100) |D* equal(D,100)"


gdal_calc.py \
-A roi.excluded_tmp.tif \
--outfile=roi.excluded.tif \
--calc="A*equal(A,100)  + 1*equal(A,0)"


gdal_translate -of GIF roi.excluded.tif "roi.excluded.gif"

rm -rf *.tif

cp "roi.excluded.gif" ../../output
cp "roi.excluded.gif.aux.xml" ../../output

rm roi.excluded.gif roi.excluded.gif.aux.xml

echo "Delete corine directories"
echo $PWD;
find . -type d -name "clc20*raster100m" -exec rm -rv {} +

