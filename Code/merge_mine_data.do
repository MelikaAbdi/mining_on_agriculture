cd "$data_dir"
 import excel "mines/mines_time_location_ore_final (final).xlsx", firstrow clear
 drop B C*
 tostring villagecode*, replace
 drop ruralcode* countycode*
 drop if license_strt_yr==1332
 destring storage pro_storage extraction investment area, force replace
 export delimited using "mines_time_location_ore_final_arc", replace
 
 rename village village_nam
 
 //this was a wrong way and some villages was related to wrong states
 /*
  gen village = .
  destring villagecode*, replace
 foreach v of var villagecode*{
 	replace village =`v' if (village == .) & (`v'!= .) 
 }*/
 
 //the true way:
 rename village_code village
 destring isic, force replace
drop if isic>1400000000
 save "finalmine.dta", replace
 destring ave_cutie, generate(ave_cu) ignore("ppm" "نداشت" "%") force
 destring limit_cutie, generate(limit_cu) ignore("ppm" "نداشت" "%") force
 replace ave_cu = ave_cu*0.0001 if strpos(ave_cutie,"ppm")
 replace limit_cu = limit_cu*0.0001 if strpos(limit_cutie,"ppm")
 drop ave_cutie limit_cutie statecode* villagecode*
 rename ave_cu ave_cutie
 rename limit_cu limit_cutie
 destring storage pro_storage extraction investment area, force replace
 egen total_extraction = total(extraction), by(village)
 
 tostring isic, replace
  gen mineral = "iron" if isic=="1310412304" | isic=="1310412305" | isic=="1310412314" | isic=="1310312301" | isic=="1310412306" | isic=="1310412311" | isic=="1310512308" | isic=="1310412314"
 replace mineral = "titanium" if isic=="1320412232" 
 replace mineral = "chromite" if isic=="1320412313"
 replace mineral = "mangenese" if isic=="1320412321"
 replace mineral = "antimony" if isic=="1320412326"
 replace mineral = "copper" if isic=="1320512399" | isic=="1320512400" | isic=="1320412315"
 replace mineral = "gold or silver" if isic=="1320612402" | isic=="1320612403" | isic=="1320512305"
 replace mineral = "lead&zinc" if isic=="1320512398" | isic=="1320512397" | isic=="1320412309" | isic=="1320512396" | isic=="1320512395" | isic=="1320512404" | isic=="1320512405"
 
 save "finalmine.dta", replace
 
 // here use locational codes to generate statistics
 
 drop if mineral=="antimony" | mineral=="titanium"
 drop if substr(isic,1,2)=="14"
 drop if strlen(isic)>12
 
 gen ln_extraction = ln(extraction)
 hist ln_extraction if extraction<1000000,frequency bin(20) by(mineral)
 hist extraction if extraction<1000000,frequency bin(40) by(mineral)
 
 gen ln_area = ln(area)
 hist ln_area,frequency bin(200) by(mineral)
 hist area,frequency bin(400) by(mineral)
 
 sepscatter ln_area ln_extraction, separate(mineral)
 
 gen ln_ave_cutie = ln(ave_cutie)
 hist ln_ave_cutie, frequency bin(20) by(mineral)
 
 gen ln_inv = ln(investment)
 hist ln_inv, frequency bin(20) by(mineral)
 sepscatter ln_inv ln_extraction, separate(mineral)
 sepscatter ln_inv ln_area, separate(mineral)
 
 gen ln_storage = ln(storage)
 sepscatter ln_storage ln_area, separate(mineral)
 sepscatter ln_storage ln_extraction if (storage>1 & extraction>1), separate(mineral)
 
 gen tot_storage = pro_storage + storage
 gen ln_tot_storage = ln(tot_storage)
 ///

 
 preserve
 collapse (sum) extraction, by(village)
 gen ln_ex = ln(extraction)
 hist ln_ex, bin(200)
 restore
 
 
 /////for license start year
preserve
collapse (min) license_strt_yr, by(village)
tostring village, replace
export excel using "treat_strt_yr", firstrow(varlabels) replace
restore

//////for license start year and extraction
preserve
collapse (min) license_strt_yr (sum) extraction (sum) area, by(village isic)
tostring village, replace
rename license_strt_yr license_st
export dbase using "treat_strt_yr_and_ext_and_area_isic", replace
restore

preserve
gen iron = 1 if mineral=="iron"
gen copper=1 if mineral=="copper"
gen gold = 1 if mineral=="gold or silver"
gen lead = 1 if mineral=="lead&zinc"
gen mangenese = 1 if mineral=="mangenese"
gen chromite=1 if mineral=="chromite"
graph bar (count) iron copper gold lead mangenese chromite, over(license_st) stack
restore


///////
cd "$results_dir"
cd "stats of mines"
putexcel set mine_stat, replace
//putexcel A1 = "Variable", border(bottom) font("B Nazanin") vcenter hcenter
putexcel B1 = "آهن", border(bottom) font("B Nazanin") vcenter hcenter
putexcel C1 = "طلا", border(bottom) font("B Nazanin") vcenter hcenter
putexcel D1 = "مس", border(bottom) font("B Nazanin") vcenter hcenter
putexcel E1 = "سرب و روی", border(bottom) font("B Nazanin") vcenter hcenter
putexcel F1 = "منگنز", border(bottom) font("B Nazanin") vcenter hcenter
putexcel G1 = "کرومیت", border(bottom) font("B Nazanin") vcenter hcenter

putexcel A2 = "لگاریتم مساحت", border(right) top hcenter font("B Nazanin") 
putexcel A4 = "لگاریتم استخراج سالانه", border(right) top hcenter font("B Nazanin") 
putexcel A6 = "لگاریتم سرمایه‌گذاری", border(right) top hcenter font("B Nazanin") 
putexcel A8 = "لگاریتم ذخیرهٔ معدن", border(right) top hcenter font("B Nazanin")
putexcel A10 = "تعداد مشاهدات", border(right) top hcenter font("B Nazanin")

putexcel (A2:A3), merge
putexcel (A4:A5), merge
putexcel (A6:A7), merge
putexcel (A8:A9), merge

foreach m in "iron" "gold or silver" "copper" "lead&zinc" "mangenese" "chromite"{
	if "`m'"=="iron" local c="B" 
	if "`m'"=="gold or silver" local c="C" 
	if "`m'"=="copper" local c="D" 
	if "`m'"=="lead&zinc" local c="E" 
	if "`m'"=="mangenese" local c="F" 
	if "`m'"=="chromite" local c="G" 
	local i=2
	foreach var of varlist ln_area ln_ex ln_inv ln_storage{
		local j = `i'+1
		sum `var' if mineral=="`m'"
		return list
		putexcel `c'`i' = `r(mean)', nformat(number_d2) vcenter hcenter font("B Nazanin")
		putexcel `c'`j' = -`r(sd)', nformat(number_d2_sep_negbra) vcenter hcenter font("B Nazanin")
		local i = `i'+2
	}
	putexcel `c'`i' = `r(N)', nformat(number) vcenter hcenter font("B Nazanin")
}





graph bar (count) code, over(license_strt_yr, label(angle(vertical) labsize(vsmall))) ytitle(تعداد معدن) by(, title(تعداد پروانه‌های معدن فلزی صادر شده در سال‌های مختلف) note("")) by(, legend(off)) by(mineral)
graph export trends.png, replace