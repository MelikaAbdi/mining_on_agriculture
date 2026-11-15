cd "$data_dir"
 import delimited "agriculture/farm_ex.csv", clear
 
 drop v1
 drop if crop !="Wheat"
drop crop 
rename arzeshbazr hazbazr
 
 gen village_nam = ""
 foreach v of var village_name*{
 	replace village_nam =`v' if (village_nam == "") & (`v'!= "") 
 }
  drop village_name*
 
 
 merge m:m village using finalmine //380 not matched from using. there was 125 villages with no code so 255 mines of 635 mineral villages where not in agri data
 drop if _merge==2
 
 
  gen rural_nam = ""
 foreach r of var rural_name*{
  	replace rural_nam =`r' if (rural_nam == "") & (`r'!= "") 
  }
 drop rural_name*
 
 
 ///summarize spendings
 egen haznirookar = rowtotal(haznirokar* haznirofam*)
 drop haznirokar* haznirofam*

 egen nafruzkar = rowtotal(nafroozkar* nafroozfam*)
 drop nafroozkar* nafroozfam* //may have problem

 egen hazhml = rowtotal(hazhaml*) 
 drop hazhaml*
 
egen hazbardmchn = rowtotal(hazcombine hazdrowgar hazbardsayermchn hazjamhamlmchn hazsayerbardashtmchn)
drop hazcombine hazdrowgar hazbardsayermchn hazjamhamlmchn hazsayerbardashtmchn

egen hazdashtmchn = rowtotal(hazsayerdashtmchn hazsampashimchn hazvejinmchn hazabiarithtfeshard)
drop hazsayerdashtmchn hazsampashimchn hazvejinmchn hazabiarithtfeshard 

egen hazdashtnmchn = rowtotal(hazsayerdashtnmchn hazbiologic)
drop hazsayerdashtnmchn hazbiologic

egen hazkashtmchn = rowtotal(hazsayerkashtmchn hazkoodpashishmchn hazkoodpashihmchn hazsayeramdsazimchn hazkertbandimchn hazmalemchn hazdiskmchn hazshokmmchn hazabiarithtfeshar) //hazsayer
drop hazsayerkashtmchn hazkoodpashishmchn hazkoodpashihmchn hazsayeramdsazimchn hazkertbandimchn hazmalemchn hazdiskmchn hazshokmmchn hazabiarithtfeshar

egen hazkashtnmchn = rowtotal(hazdamshokm hazdamdisk hazdammale hazdamkertbandi hazsayeramdsazinmchn hazsayerkashtnmchn) //hazsayer
drop hazdamshokm hazdamdisk hazdammale hazdamkertbandi hazsayeramdsazinmchn hazsayerkashtnmchn

egen hazsam = rowtotal(hazalafkosh hazhasharekosh hazqarchkosh hazsayersam)
drop hazalafkosh hazhasharekosh hazqarchkosh hazsayersam

egen mgdsam = rowtotal(mgdalafkosh mgdhasharekosh mgdqarchkosh mgdsayersam)  // problematic: can not add sam of different types
drop mgdalafkosh mgdhasharekosh mgdqarchkosh mgdsayersam

egen hazkud = rowtotal(hazkood*)
drop hazkood*

egen mgdkud = rowtotal(mgdkood*)
drop mgdkood*


////normalizing
gen rent_norm = rent/fland
gen wage_norm = haznirookar/nafruzkar
gen abbaha_norm = abbaha/dafeatabiari
gen hazkud_norm = hazkud/mgdkud
gen hazsam_norm = hazsam/mgdsam
gen yield = production/fland

drop _merge
merge m:m year using "PPI/ppiAnnualData"
drop if _merge==2
replace rent = rent/ppi*100
foreach v of varlist haz*{
    replace `v' = `v'/ppi*100
} 
replace abbaha = abbaha/ppi*100
drop _merge


save farm_and_mine, replace
 