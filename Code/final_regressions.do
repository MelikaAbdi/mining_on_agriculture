graph set window fontface "B Mitra"
grstyle init
//grstyle set imesh, horizontal //(makes gray background)
grstyle set color tableau
grstyle set lpattern
grstyle set symbol
grstyle set graphsize 5 10
grstyle set size 16pt: key_label tick_label axis_title
grstyle set linewidth .5
/////final regressions////////
cd "$data_dir"
global path "$results_dir"
//global tables "$path/Tables"
global tables "$path/TablesWithoutMineral_srtyrdropup"
//global graphs "$path/Graphs"
global graphs "$path/GraphsWithoutMineral_strtyrrdropup"
mkdir $tables
mkdir $graphs
cd $path

local treat_lvl = "cu_total au_total fe_total pb_total mn_total cr_total"
local t=25
local t_0 = `t'-0.5
local t_1 = `t'-1
///control in 80 radius///
foreach y of numlist 5 10 20 40{
	use data_for_ddd`y', clear
	replace nafruzkar = nafruzkar/1000
	replace fland = fland/100
	replace extraction = extraction/1000000
	//keep if norm_yr<20 & norm_yr>-20
	//keep if license_st>=1382
	preserve
	reghdfe ln_yield did treat postt if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'Irrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES, year-rural FE, NO, water FE, NO)
	
	reghdfe ln_yield did treat postt Distance extraction area if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, NO, water FE, NO)
	
	reghdfe ln_yield did treat postt Distance extraction area if irr=="Irrigated", absorb(year##rural_code codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	reghdfe ln_yield did treat postt Distance extraction area fland nafruzkar if irr=="Irrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,year-rural FE, YES, water FE, NO)
	
	reghdfe ln_yield did treat postt Distance extraction area fland nafruzkar dafeatabiari if irr=="Irrigated", absorb(rural_code##year codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	reghdfe ln_yield did treat postt Distance area fland nafruzkar dafeatabiari `treat_lvl' if irr=="Irrigated", absorb(rural_code##year codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	drop if norm_yr>20 | norm_yr<-20
	replace norm_yr = norm_yr+25
	reghdfe yield treat##ib(`t_1').norm_yr if irr=="Irrigated", absorb(year##rural_code) vce(robust)
	coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
		rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
		yline(0, lp(solid)) xline(`t_0', lpattern(dash)) ///
		xlab(`t' "0") title(بررسی روندهای موازی) ytitle(بازدهی-کیلوگرم بر هکتار) subtitle(کشت آبی) note(گروه تیمار: شعاع `y' کیلومتری معدن)
	graph export $graphs/`y'Irrigated_within80_final.png, replace
	restore
		
	///////
	
	reghdfe fland did treat postt if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'fland_Irrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES, year-rural FE, NO, water FE, NO)
	
	reghdfe fland did treat postt Distance extraction area if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'fland_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, NO, water FE, NO)
	
	reghdfe fland did treat postt Distance extraction area if irr=="Irrigated", absorb(year##rural_code codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'fland_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	reghdfe fland did treat postt Distance extraction area nafruzkar if irr=="Irrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'fland_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,year-rural FE, YES, water FE, NO)
	
	reghdfe fland did treat postt Distance extraction area nafruzkar dafeatabiari if irr=="Irrigated", absorb(rural_code##year codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'fland_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	reghdfe fland did treat postt Distance area nafruzkar dafeatabiari `treat_lvl' if irr=="Irrigated", absorb(rural_code##year codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'fland_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	///////
	
	reghdfe nafruzkar did treat postt if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_Irrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES, year-rural FE, NO, water FE, NO)
	
	reghdfe nafruzkar did treat postt Distance extraction area if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, NO, water FE, NO)
	
	reghdfe nafruzkar did treat postt Distance extraction area if irr=="Irrigated", absorb(year##rural_code codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	reghdfe nafruzkar did treat postt Distance extraction area fland if irr=="Irrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,year-rural FE, YES, water FE, NO)
	
	reghdfe nafruzkar did treat postt Distance extraction area fland dafeatabiari if irr=="Irrigated", absorb(rural_code##year codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	reghdfe nafruzkar did treat postt Distance area fland dafeatabiari `treat_lvl' if irr=="Irrigated", absorb(rural_code##year codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
			
	
	///////
	reghdfe dafeatabiari did treat postt if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'dafeatabiari_Irrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES, year-rural FE, NO, water FE, NO)
	
	reghdfe dafeatabiari did treat postt Distance extraction area if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'dafeatabiari_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, NO, water FE, NO)
	
	reghdfe dafeatabiari did treat postt Distance extraction area if irr=="Irrigated", absorb(year##rural_code codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'dafeatabiari_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	reghdfe dafeatabiari did treat postt Distance extraction area fland if irr=="Irrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'dafeatabiari_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,year-rural FE, YES, water FE, NO)
	
	reghdfe dafeatabiari did treat postt Distance extraction area fland nafruzkar if irr=="Irrigated", absorb(rural_code##year codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'dafeatabiari_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
	
	reghdfe dafeatabiari did treat postt Distance area fland nafruzkar `treat_lvl' if irr=="Irrigated", absorb(rural_code##year codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'dafeatabiari_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES, water FE, YES)
			
	
	///////
	preserve
	reghdfe ln_yield did treat postt if irr=="Nonirrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'NonIrrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES,  year-rural FE, NO)

	reghdfe ln_yield did treat postt Distance area extraction if irr=="Nonirrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, NO)

	reghdfe ln_yield did treat postt Distance area extraction if irr=="Nonirrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
 
	reghdfe ln_yield did treat postt Distance area extraction fland nafruzkar if irr=="Nonirrigated", absorb(rural_code year) vce(cluster village)
	outreg2 using $tables/`y'NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, NO)

	reghdfe ln_yield did treat postt Distance area extraction fland nafruzkar if irr=="Nonirrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	reghdfe ln_yield did treat postt Distance area fland nafruzkar `treat_lvl' if irr=="Nonirrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	
	drop if norm_yr>15 | norm_yr<-15
	replace norm_yr = norm_yr+25
	reghdfe yield treat##ib(`t_1').norm_yr if irr=="Nonirrigated", absorb(year##rural_code) vce(robust)
	coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
		rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
		yline(0, lp(solid)) xline(`t_0', lpattern(dash)) ///
		xlab(`t' "0") title(بررسی روندهای موازی) ytitle(بازدهی-کیلوگرم بر هکتار) subtitle(کشت دیم) note(گروه تیمار: شعاع `y' کیلومتری معدن)
	graph export $graphs/`y'NonIrrigated_within80_final.png, replace
	restore
	////////
	
	reghdfe fland did treat postt if irr=="Nonirrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'fland_NonIrrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES,  year-rural FE, NO)

	reghdfe fland did treat postt Distance area extraction if irr=="Nonirrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'fland_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, NO)

	reghdfe fland did treat postt Distance area extraction if irr=="Nonirrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'fland_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
 
	reghdfe fland did treat postt Distance area extraction nafruzkar if irr=="Nonirrigated", absorb(rural_code year) vce(cluster village)
	outreg2 using $tables/`y'fland_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, NO)

	reghdfe fland did treat postt Distance area extraction nafruzkar if irr=="Nonirrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'fland_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	reghdfe fland did treat postt Distance area nafruzkar `treat_lvl' if irr=="Nonirrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'fland_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	////////
	
	reghdfe nafruzkar did treat postt if irr=="Nonirrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_NonIrrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES,  year-rural FE, NO)

	reghdfe nafruzkar did treat postt Distance area extraction if irr=="Nonirrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, NO)

	reghdfe nafruzkar did treat postt Distance area extraction if irr=="Nonirrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
 
	reghdfe nafruzkar did treat postt Distance area extraction fland if irr=="Nonirrigated", absorb(rural_code year) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, NO)

	reghdfe nafruzkar did treat postt Distance area extraction fland if irr=="Nonirrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	reghdfe nafruzkar did treat postt Distance area fland `treat_lvl' if irr=="Nonirrigated", absorb(rural_code##year) vce(cluster village)
	outreg2 using $tables/`y'nafruzkar_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	
	///////
	preserve
	reghdfe deep did treat postt Distance area extraction if irr=="Irrigated", absorb(year county_code90) vce(cluster village)
	outreg2 using $tables/`y'adapt_within80_final.doc, replace addtext(year FE, YES, rural FE, YES, county FE, YES)
	
	reghdfe deep did treat postt Distance area extraction r85 if irr=="Irrigated", absorb(year) vce(cluster village)
	outreg2 using $tables/`y'adapt_within80_final.doc, addtext(year FE, YES, rural FE, NO, county FE, NO)
	
	reghdfe deep did treat postt Distance area extraction fland dafeatabiari nafruzkar r85 if irr=="Irrigated", absorb(year county_code90) vce(cluster village)
	outreg2 using $tables/`y'adapt_within80_final.doc, addtext(year FE, YES, rural FE, NO, county FE, YES)
	
	reghdfe deep did treat postt Distance area fland dafeatabiari `treat_lvl' nafruzkar r85 if irr=="Irrigated", absorb(year county_code90) vce(cluster village)
	outreg2 using $tables/`y'adapt_within80_final.doc, addtext(year FE, YES, rural FE, YES, county FE, YES)
	
	reghdfe deep did treat postt Distance area fland dafeatabiari `treat_lvl' nafruzkar r85 if irr=="Irrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'adapt_within80_final.doc, addtext(year FE, YES, rural FE, YES, rural_year FE, YES)
	
	
	drop if norm_yr>20 | norm_yr<-20
	replace norm_yr = norm_yr+25
	reghdfe deep treat##ib(`t_1').norm_yr if irr=="Irrigated", absorb(year##rural_code) vce(robust)
	coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
		rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
		yline(0, lp(solid)) xline(`t_0', lpattern(dash)) ///
		xlab(`t' "0") title(بررسی روندهای موازی) ytitle(بازدهی-کیلوگرم بر هکتار) subtitle(شواهد افزایش استفاده از منابع آب زیرزمینی) note(گروه تیمار: شعاع `y' کیلومتری معدن)
	graph export $graphs/`y'adapt_within80_final.png, replace
	restore
	
	 ///////
	
	preserve
	reghdfe irri did treat postt Distance area extraction, absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'adapt_irr_within80_final.doc, replace addtext(year FE, YES, rural FE, YES,  year-rural FE, NO, water FE, NO)
	
	reghdfe irri did treat postt Distance area extraction r85, absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'adapt_irr_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, YES, water FE, NO)
	
	reghdfe irri did treat postt Distance area extraction fland nafruzkar r85, absorb(year##rural_code codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'adapt_irr_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, YES, water FE, YES)
	
	reghdfe irri did treat postt Distance area fland `treat_lvl' nafruzkar r85, absorb(year##rural_code codmanbaab) vce(cluster village)
	outreg2 using $tables/`y'adapt_irr_within80_final.doc, addtext(year FE, YES, rural FE, YES,  year-rural FE, YES, water FE, YES)
	
	
	drop if norm_yr>20 | norm_yr<-20
	replace norm_yr = norm_yr+25
	reghdfe irri treat##ib(`t_1').norm_yr, absorb(year##rural_code) vce(robust)
	coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
		rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
		yline(0, lp(solid)) xline(`t_0', lpattern(dash)) ///
		xlab(`t' "0") title(بررسی روندهای موازی) ytitle(بازدهی-کیلوگرم بر هکتار) subtitle(شواهد کاهش نرخ کشت آبی) note(گروه تیمار: شعاع `y' کیلومتری معدن)
	graph export $graphs/`y'adapt_irr_within80_final.png, replace
	restore
	
	 ///////
	
	 keep if license_st>=1385 & license_st<=1390
	 gen road=1 if r85==1
	 replace road=0 if r85==0 & r90==0
	 generate did0 = post & treat & (road)
	 gen did1 = post & treat
	 gen did2 =(post) & road
	 gen did3 = treat & road
	 
	preserve
	reghdfe ln_yield did0 did1 did2 did3 treat postt road if irr=="Nonirrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'ddd_NonIrrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES, year-rural FE, NO)
	
	reghdfe ln_yield did0 did1 did2 did3 treat postt road if irr=="Nonirrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'ddd_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	reghdfe ln_yield did0 did1 did2 did3 treat postt road fland nafruzkar Distance extraction area if irr=="Nonirrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'ddd_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	reghdfe ln_yield did0 did1 did2 did3 treat postt road fland nafruzkar Distance area `treat_lvl' if irr=="Nonirrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'ddd_NonIrrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	
	drop if norm_yr>20 | norm_yr<-20
	replace norm_yr = norm_yr+25
	reghdfe yield treat##ib(`t_1').norm_yr if irr=="Nonirrigated", absorb(year##rural_code) vce(robust)
	coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
		rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
		yline(0, lp(solid)) xline(`t_0', lpattern(dash)) ///
		xlab(`t' "0") title(بررسی روندهای موازی) ytitle(بازدهی-کیلوگرم بر هکتار) subtitle(اثر مداخله بر کشت دیم در روستاهای دارای جاده شوسه یا آسفالت) note(گروه تیمار: شعاع `y' کیلومتری معدن)
	graph export $graphs/`y'ddd_NonIrrigated_within80_final.png, replace
	restore
	
	///////
	preserve
	reghdfe ln_yield did0 did1 did2 did3 treat postt road if irr=="Irrigated", absorb(year rural_code) vce(cluster village)
	outreg2 using $tables/`y'ddd_Irrigated_within80_final.doc, replace addtext(year FE, YES, rural FE, YES, year-rural FE, NO)
	
	reghdfe ln_yield did0 did1 did2 did3 treat postt road if irr=="Irrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'ddd_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	reghdfe ln_yield did0 did1 did2 did3 treat postt road fland nafruzkar dafeatabiari Distance extraction area if irr=="Irrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'ddd_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	reghdfe ln_yield did0 did1 did2 did3 treat postt road fland nafruzkar dafeatabiari Distance area `treat_lvl' if irr=="Irrigated", absorb(year##rural_code) vce(cluster village)
	outreg2 using $tables/`y'ddd_Irrigated_within80_final.doc, addtext(year FE, YES, rural FE, YES, year-rural FE, YES)
	
	
	drop if norm_yr>20 | norm_yr<-20
	replace norm_yr = norm_yr+25
	reghdfe yield treat##ib(`t_1').norm_yr if irr=="Irrigated", absorb(year##rural_code) vce(robust)
	coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
		rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
		yline(0, lp(solid)) xline(`t_0', lpattern(dash)) ///
		xlab(`t' "0") title(بررسی روندهای موازی) ytitle(بازدهی-کیلوگرم بر هکتار) subtitle(اثر مداخله بر کشت آبی در روستاهای دارای جاده شوسه یا آسفالت) note(گروه تیمار: شعاع `y' کیلومتری معدن)
	graph export $graphs/`y'ddd_Irrigated_within80_final.png, replace
	restore
	

}


foreach y of numlist 5 10 20 40{
	use data_for_ddd`y', clear
	rename did did`y'
	reghdfe ln_yield did treat postt Distance extraction area fland nafruzkar if irr=="Nonirrigated", absorb(rural_code##year) vce(cluster village)
	estimates store base`y'
	
	reghdfe ln_yield did treat postt Distance extraction area fland nafruzkar if irr=="Nonirrigated", absorb(rural_code year) vce(cluster village)
	estimates store nofe_base`y'

}

	coefplot (base5,keep(did5)\base10,keep(did10)\base20,keep(did20)\base40,keep(did40)\) (nofe_base5,keep(did5)\nofe_base10,keep(did10)\nofe_base20,keep(did20)\nofe_base40,keep(did40)\), baselevels recast(connected) order(base10:did base20:did base40:did)  ///
		xlab(`t' "0") title(بررسی کمرنگ شدن کاهش بازدهی با فاصله گرفتن از معدن) ytitle(لگاریتم بازدهی-کیلوگرم بر هکتار) xtitle(فاصله از معدن) omitted relocate(did5=5 did10 = 10  did20=20 did40=40) xlab(0 "0" 5 "5km" 10 "10km" 20 "20km" 40 "40km") legend(order(1 "با اثر ثابت دهستان-سال" 3 "بدون اثر ثابت دهستان-سال")) vertical
		
		graph export fade_away.png, replace