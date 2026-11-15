
local y = 10

use data_for_ddd`y', clear


preserve
use data_for_ddd, clear
//keep if license_st>=1385 & license_st<=1390
drop if license_st==1332
drop if norm_yr>20 | norm_yr<-20
replace norm_yr = norm_yr+25
destring rural_code, replace
gen ln_extraction = ln(extraction)
drop if ln_extraction>15
reghdfe deep treat##ib(24).norm_yr Distance extraction fland if irr=="Irrigated", absorb(year##rural_code) vce(cluster village)
local c = _cons
coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
	rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
	yline(0, lp(solid)) xline(24.5, lpattern(dash)) ///
	xlab(5(1)45)
reghdfe deep treat did Distance extraction fland nafruzkar if irr=="Irrigated", absorb(rural_code##year) vce(cluster village)
outreg2 using `y'Irrigated.doc, replace addtext(rural-year FE, YES)
restore //better for r=10 than 20 butt no parallel. nothing can be recognised if keep if license_st>=1385 & license_st<=1390 - not very obvous in 5 but not so bad - for control 40 conf intervals become bigger

preserve
use data_for_ddd, clear
gen irri = 1 if irr=="Irrigated"
replace irri=0 if irr == "Nonirrigated"
//keep if license_st>=1385 & license_st<=1390
drop if license_st==1332
drop if norm_yr>15 | norm_yr<-15
replace norm_yr = norm_yr+25
destring rural_code, replace
reghdfe irri treat##ib(24).norm_yr Distance extraction fland, absorb(year##rural_code) vce(robust)
local c = _cons
coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
	rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
	yline(0, lp(solid)) xline(24.5, lpattern(dash)) ///
	xlab(10(1)40)
reghdfe irri treat did Distance extraction, absorb(year##rural_code) vce(robust)
outreg2 using `y'Irrigated.doc, addtext(rural-year FE, YES)
restore // similat results to previous for 10

preserve
use data_for_ddd, clear
//keep if license_st>=1385 & license_st<=1390
drop if license_st==1332
drop if norm_yr>15 | norm_yr<-15
replace norm_yr = norm_yr+25
destring rural_code, replace
reghdfe yield treat##ib(24).norm_yr Distance extraction nafruzkar if irr=="Irrigated" & r90==1 & r85==1, absorb(rural_code##year) vce(robust)
local c = _cons
coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
	rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
	yline(0, lp(solid)) xline(24.5, lpattern(dash)) ///
	xlab(10(1)40)
restore // no change for 10 with and without keep and also irr and noirr no difference - drop and then rize when r=1.

preserve
use data_for_ddd, clear

keep if license_st>=1382
drop if license_st==1332
drop if norm_yr>20 | norm_yr<-20
replace norm_yr = norm_yr+25
gen ln_yield = ln(yield)
drop if area>1000
gen ln_fland = ln(fland)
drop if ln_fland>5 | ln_fland<-2
tab norm_yr treat
destring rural_code, replace
reghdfe yield treat##ib(24).norm_yr Distance extraction nafruzkar if irr=="Nonirrigated", absorb(rural_code##year) vce(cluster village)
local c = _cons
coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
	rename(1.treat#([0-9]+).norm_yr = \1, regex) at(_coef) ///
	yline(0, lp(solid)) xline(24.5, lpattern(dash)) ///
	xlab(25 "0")	
reghdfe yield treat did Distance extraction nafruzkar if irr=="Irrigated", absorb(rural_code##year) vce(cluster village)
outreg2 using `y'Irrigated.doc, addtext(rural-year FE, YES)
restore //good for 5 but should be one year forward - bad for 10 - becomes good when keep (very good for 20-not very good for 10-bad for 5) ///when dropped nonmetals results very good for 20 - absorb(rural_code year) has less variance - for 10 a increase(or no change) for 6 years after treat and then drop (with keep if license_st>=1385 & license_st<=1390 and r85=1)- for 5k without drop and r85==1 rise drop and rise - when absorb(rural_code##year) some points does not hase conf interval - 



///////////
preserve
 //making did var
  gen r85=0 if road85=="3" | road85=="4"
 replace r85=1 if road85=="1" | road85=="2" | road85=="5"
 generate did0 = post & treat & (r85)
 gen did1 = post & treat
 gen did2 =(post) & r85
 gen did3 = treat & r85
 drop if license_strt_yr==0
 
 //regressions
 reghdfe yield did0##codmanbaab did1 did2 did3 treat r85 post fland nafruzkar Distance extraction if irr=="Irrigated", absorb(year#county_code90 dafeatabiari) vce(cluster village)
  reghdfe yield did0 did1 did2 did3 treat r85 post fland nafruzkar Distance extraction if irr=="Nonirrigated", absorb(year#county_code90) vce(cluster village)
 restore
///////////
use data_for_ddd, clear
//keep if license_st>=1385 & license_st<=1390
 gen r85=0 if road85=="3" | road85=="4"
 replace r85=1 if road85=="1" | road85=="2" | road85=="5"
  gen r90=0 if road90=="3" | road90=="4"
 replace r90=1 if road90=="1" | road90=="2" | road90=="5"
  gen deep=1 if (codmanbaab==4) | (codmanbaab==5)
 replace deep=0 if (codmanbaab==1) | (codmanbaab==2) | (codmanbaab==3) | (codmanbaab==8) | (codmanbaab==9)| (codmanbaab==6)
drop if license_st==1332
histogram yield if irr=="Irrigated", normal kdensity by(deep)