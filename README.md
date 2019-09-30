# Πρόβλεψη νυχτερινών φώτων  DMSP/OLS για τις ελληνικές πόλεις με το μοντέλο SLEUTH.

Στο τρέχον αποθετήριο καταγράφεται η διαδικασία προεπεξεργασίας και προετοιμασίας των απαραίτητων δεδομένων για την πρόβλεψη της έκτασης των νυχτερινών φώτων DMSP/OLS στο Ελλαδικό χώρο για την περίοδο 2013-2030 με το μοντέλο [SLEUTH](http://www.ncgia.ucsb.edu/projects/gig/index.html).

Τα απαραίτητα δεδομένα για την εκτέλεση του μοντέλου είναι:

* Καλύψη γης: [CORINE Land Cover (CLC) ] (https://land.copernicus.eu). Τα δεδομένα πρέπει να τα λάβει ο χρήστης από το σχετικό site (αρχεία clc2000_clc1990_v2018_20_raster100m.zip, clc2012_clc2006_v2018_20_raster100m.zip, clc2006_clc2000_v2018_20_raster100m.zip. clc2018_clc2012_v2018_20_raster100m.zip)

* Οδικό δίκτυο: [Open Street Map](https://planet.openstreetmap.org/planet/full-history/) . Έχει χρησιμοποιηθεί το αρχείο *history-190715.osm.pbf*

* Κλίση και σκίαση εδάφους, παράγωγα δεδομένα από: [NASA Shuttle Radar Topography Mission Global 3 arc second V003](https://search.earthdata.nasa.gov/). Κατά την διαδικασία επιχειρείται λήψη των δεδομένων SRTM από το [https://search.earthdata.nasa.gov/](https://search.earthdata.nasa.gov/). Για ρύθμιση της πρόσβασης για την λήψη των δεδομένων SRTM απαιτείται παραμετροποίηση σύμφωνα με τις οδηγίες που παρέχονται στο σχετικό [ιστότοπο για το curl και wget ](https://wiki.earthdata.nasa.gov/display/EL/How+To+Access+Data+With+cURL+And+Wget).

* διαβαθμονομημένα δεδομένα νυχτερινών φώτων: [Version 4 DMSP-OLS Nighttime Lights Time Series](https://ngdc.noaa.gov/eog/dmsp/downloadV4composites.html) διατίθενται έτοιμα προς χρήση κατόπιν προγενέστερης επεξεργασίας. Επειδή τα δεδομένα DMSP/OLS πάσχουν από το overglow έχει εφαρμοστεί καθολικό φίλτρο με το οποίο διατηρούνται μόνο οι τιμές με DN>30.

Για την προεπεξεργασία και διαμόρφωση των δεδομένων στον κατάλληλο μορφότυπο ώστε να εξασφαλιστεί η συμβατότητά τους με το μοντέλο SLEUTH εκτελούνται μια σειρά από bash script με την χρήση των βιβλιοθηκών gdal (gdalwarp,gdal_translate, gdaldem, gdal_calc, gdaldem) και της γλώσσας προγραμματισμού R.
Η διαδοχή των script για την επεξεργασία των δεδομένων περιέχεται σε αρχείο Makefile και για την εκτέλεση του αρκεί να εκτελεστεί η εντολή:

```console
make
```

Το αρχείο config.sh περιέχει τις παραμέτρους για την γεωγραφική έκταση (extension) και την διακριτική ικανότητα (resolution) των παραγόμενων δεδομένων.

