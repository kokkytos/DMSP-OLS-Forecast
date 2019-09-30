.PHONY: clean 

all: srtm corine ols osm cptoSleuthDir

srtm:
	cd ./source;	\
	./dowloadSRTM.sh; \
	./srtm.sh;

corine:
	cd ./source;	 \
	./corine.sh; \
	./merge_e.sh

ols:
	cd ./source; \
	./mask_ols_with_e.sh

osm:
	cd ./source; \
	./extract_highways_history.sh

clean:
	cd ./output; \
	find . ! -name '.gitignore' -type f -exec rm -f {} +

