steps to make files of this folder:

0- crawl jpg files of extraction permissions from https://cadastre.mimt.gov.ir/
   (this makes the folder Data/final list of mines_jpg

1- collect information of mineral villages from the jpg files of extraction permissions 
   (this makes the file "mines_time_location_ore_final (final).xlsx")

2- match the address code for each village using the 6digit statistical code from 1390 census
   (6digit codes of villages can be found in Data/geo codes)

3- match the mineral village codes with shape layer of Iran villages in the folder named "village" and find mineral villages on the shapefile 
   (this makes the files in the folder "metal mineral villages")

4- join the nearest mineral village properties with different treatment groups (5,10,20,40,80 radius of mineral villages)
   (this makes the files in the folder "mineral villages with start year and extraction of nearest mine")