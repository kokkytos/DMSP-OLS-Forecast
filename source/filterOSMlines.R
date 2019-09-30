library(rgdal)
library(spdplyr)

args <- commandArgs(trailingOnly = TRUE)

YEAR=as.numeric(args[1])
ROOTDIR <- as.character(args[2])
  
setwd(ROOTDIR)
message(ROOTDIR)

shp<-sprintf("osm%s_highways_roi_join_2100.shp",YEAR)
lines_osm<- scan("../../source/delete.txt")

osm <- rgdal::readOGR(shp, stringsAsFactors=F)


lines<-osm %>% select(lines.osm_,joincsv.ID) %>% filter(!lines.osm_ %in% lines_osm)
  
writeOGR(lines, ROOTDIR, sprintf("lines_%s",YEAR), driver="ESRI Shapefile",overwrite_layer=T)

