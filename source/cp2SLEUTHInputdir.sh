#!/bin/bash

cd ../output

#create some copies for roads
cp roi.roads.2008.gif roi.roads.1992.gif
cp roi.roads.2008.gif.aux.xml roi.roads.1992.gif.aux.xml
cp roi.roads.2008.gif roi.roads.2000.gif
cp roi.roads.2008.gif.aux.xml roi.roads.2000.gif.aux.xml

cp *.gif ../../SLEUTH3.0beta_p01_linux/Input/greece
