
 //year 90
 cd "$data_dir"
 import excel "farhang abadi\abadi_90_os00.xlsx", cellrange(A2) firstrow clear
 rename کداستان state_code
 rename کدشهرستان county_code
 rename کدبخش division_code
 rename کددهستان rural_code
 rename کدحوزه block_code
 rename کدآبادی village
 rename ناماستان state_name
 rename نامشهرستان county_name
 rename نامبخش division_name
 rename نامدهستان rural_name
 rename نامآبادی village_name
 rename L nature
 rename راهزميني road90
 destring village, replace
 keep road nature village rural_code
 save village_property90, replace
 
 forvalues x = 1/29{
 	if `x'<10{
		import excel "farhang abadi\abadi_90_os0`x'.xlsx", cellrange(A2) firstrow clear		
	}
	
	else{
		import excel "farhang abadi\abadi_90_os`x'.xlsx", cellrange(A2) firstrow clear	
	}
	
	rename کداستان state_code
	rename کدشهرستان county_code
	rename کدبخش division_code
	rename کددهستان rural_code
	rename کدحوزه block_code
	rename کدآبادی village
	rename ناماستان state_name
	rename نامشهرستان county_name
	rename نامبخش division_name
	rename نامدهستان rural_name
	rename نامآبادی village_name
	rename L nature
	rename راهزميني road90
	destring village, replace
	keep road nature village rural_code
	append using village_property90
	save village_property90, replace
 	
 }
 
 use farm_and_mine, clear
 merge m:m village using village_property90
  save farm_and_mine, replace
 
 //year 85
 
 import excel "farhang abadi\ABADY00.XLS", cellrange(A4) firstrow clear
 rename A amar_code
 gen village = substr(amar_code,14,6)
 gen rural_code = substr(amar_code,7,4) //not sure if its true
 rename استان state_name
 rename شهرستان county_name
 rename بخش division_name
 rename دهستان rural_name
 rename آبادي village_name
 rename G nature
 rename راهزميني road85
 destring village, replace
 keep road nature village rural_code
 save village_property85, replace
 
 forvalues x = 1/29{
 	if `x'<10{
		import excel "farhang abadi\ABADY0`x'.XLS", cellrange(A4) firstrow clear		
	}
	
	else{
		import excel "farhang abadi\ABADY`x'.XLS", cellrange(A4) firstrow clear	
	}
	
	rename A amar_code
 gen village = substr(amar_code,14,6)
 gen rural_code = substr(amar_code,7,4) //not sure if its true
 rename استان state_name
 rename شهرستان county_name
 rename بخش division_name
 rename دهستان rural_name
 rename آبادي village_name
 rename G nature
 rename راهزميني road85
 destring village, replace
 keep road nature village rural_code
 append using village_property85
 save village_property85, replace
 	
 }
 
 use farm_and_mine, clear
  drop _merge
 merge m:m village using village_property85
 drop _merge
 save farm_and_mine, replace
 