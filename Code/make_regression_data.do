cd "$data_dir"
foreach y of numlist 5 10 20 40{
	import dbase using "gis\strt_yr_and_extr_mines_within_80_kms.dbf", clear
	drop year
	rename village village_code
	rename ID2 village
	destring village, replace
	tostring license_st, replace
	destring license_st, replace

	merge m:m village using "farm_and_mine.dta"

	//eslah kon badan////////////////////

	 //gen mine=1 if license_strt_yr!=.
	 //replace mine=0 if mine==.
	 ////////////////////////////////////

	 drop if _merge!=3
	 gen treat=0 
	 drop if treat==.
	 drop _merge
	 drop if license_st>1397 //| license_st<1380
	 
	 save treat_and_control_villages, replace
	 
	 
	 import dbase using "gis\strt_yr_and_extr_mines_within_`y'_kms.dbf", clear
	 drop year
	rename village village_code
	rename ID2 village
	destring village, replace
	//rename Name rural_nam
	//drop code

	merge m:m village using treat_and_control_villages

	replace treat=1 if _merge==3

	//eslah kon badan////////////////////
	 //drop if mine==1
	 ////////////////////////////////////
	// drop if license_strt_yr!=.
	 

	 
	 gen post=1 if (year>license_st)
	 replace post=0 if post==.
	 gen did = post*treat
	 drop if license_st==0
	 
	 //drop if yield>8000

	 //gen normalized year
	 //drop if year>1397 | year<1378
	 gen norm_yr = year-license_st


	 ////parallel trend
	 gen ln_yield=ln(yield)
	 drop if (ln_yield<4 | ln_yield>10) & (irr=="Irrigated") //(ln_yield>10) & (irr=="Irrigated")
	 drop if (ln_yield<2 | ln_yield>9) & (irr=="Nonirrigated") //(ln_yield>9) & (irr=="Nonirrigated")
	 drop if ln_yield==.
	 
	 gen w = extraction/Distance
	 
	 
	 /*
	 preserve
	 gen irri = 1 if irr=="Irrigated"
	replace irri=0 if irr == "Nonirrigated"
	gen ln_yeild = ln(yield)
	 twoway kdensity ln_yeild if treat & !irri, xtitle(لگاریتم بازده تولید گندم  (لگاریتم کیلوگرم بر هکتار)) ytitle(چگالی احتمال) title(بازده تولید گندم دیم (لگاریتم کیلوگرم بر هکتار)) || kdensity ln_yeild if !treat & !irri, legend(order(1 "گروه تیمار" 2 "گروه شاهد")) 
	graph export `y'ln_yield_noirr.png, replace

	twoway kdensity ln_yeild if treat, xtitle(لگاریتم بازده تولید گندم  (لگاریتم کیلوگرم بر هکتار)) ytitle(چگالی احتمال) || kdensity ln_yeild if !treat, legend(order(1 "گروه تیمار" 2 "گروه شاهد")) by(irr) 
	graph export `y'ln_yield.png, replace
	 restore
	 */
	 
	  gen r85=0 if road85=="3" | road85=="4"
	 replace r85=1 if road85=="1" | road85=="2" | road85=="5"
	  gen r90=0 if road90=="3" | road90=="4"
	 replace r90=1 if road90=="1" | road90=="2" | road90=="5"
	  gen deep=1 if (codmanbaab==4) | (codmanbaab==5) | (codmanbaab==6) // | (codmanbaab==8)| (codmanbaab==6) | (codmanbaab==7)
	 replace deep=0 if (codmanbaab==1) | (codmanbaab==2) | (codmanbaab==3) | (codmanbaab==9) //| (codmanbaab==8) | (codmanbaab==9) | (codmanbaab==10) | (codmanbaab==11)
	 
	 gen irri = 1 if irr=="Irrigated"
	replace irri=0 if irr == "Nonirrigated"

	destring rural_code, replace
	replace rural_code=county_code90*10000+rural_code
	
	egen cu_total = total(extraction) if mineral=="copper", by(rural_code)
	replace cu_total=0 if cu_total==.
	egen fe_total = total(extraction) if mineral=="iron", by(rural_code)
	replace fe_total=0 if fe_total==.
	egen cr_total = total(extraction) if mineral=="chromite", by(rural_code)
	replace cr_total=0 if cr_total==.
	egen mn_total = total(extraction) if mineral=="mangenese", by(rural_code)
	replace mn_total=0 if mn_total==.
	egen au_total = total(extraction) if mineral=="gold or silver", by(rural_code)
	replace au_total=0 if au_total==.
	egen pb_total = total(extraction) if mineral=="lead&zinc", by(rural_code)
	replace pb_total=0 if pb_total==.
	  //////////////////////////////////////////////////////////////////////////////
	drop if license_strt_yr!=.
	save data_for_ddd`y', replace
}