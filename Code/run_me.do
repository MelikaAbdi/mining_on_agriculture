//go to the path: please change it to the path of your clone
cd "C:\Melika\thesis\data\final\mining_on_agriculture"

//set graph styles
graph set window fontface "B Mitra"
grstyle init
grstyle set color tableau
grstyle set lpattern
grstyle set symbol
grstyle set graphsize 5 10
grstyle set size 16pt: key_label tick_label axis_title
grstyle set linewidth .5

//install necessary packages 
ssc install sepscatter
ssc install addplot
ssc install coefplot

//do files 
do "Code/merge_mine_data"
do "Code/merge_farm_and_mine_data"
do "Code/merge_farm&mine_with_abadi"
do "Code/make_regression_data"
do "Code/final_regressions"