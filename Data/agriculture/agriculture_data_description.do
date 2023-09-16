graph set window fontface "B Mitra"
grstyle init
//grstyle set imesh, horizontal //(makes gray background)
grstyle set color tableau
grstyle set lpattern
grstyle set symbol
grstyle set graphsize 5 10
grstyle set size 16pt: key_label tick_label axis_title
grstyle set linewidth .5

cd "C:\Melika\thesis\data\agriculture\pourghasem-poor\Melika results"
clear
use farmYear
gen state_code = int(county_code90/100)

///دلیل مچ نشدن بعضی دهستان‌ها
gen match_code = county_code90*10^6 + village
merge m:m match_code using village_code_all.dta
drop if _merge==2
label define _merge 1 "روستاهای مجهول" 3 "روستاهای معلوم", replace 
preserve
collapse (count) village, by(year _merge)
twoway (connected village year), by(_merge, yrescale) by(,title(مقایسه تعداد روستاهای مجهول با معلوم در سال‌های مختلف داده)) xtitle(سال) ytitle(تعداد روستا)
restore
keep if _merge==3
drop _merge

///تعیین دهستان‌های شاهد و تیمار قدیمی
/*
gen treat=1 if dehestan=="بکرآباد" | dehestan=="ازومدل شمالی" | dehestan=="انگوران" | (ostan=="آذربایجان غربی" & dehestan=="احمدآباد") | dehestan=="چهاردولی شرقی" | /*dehestan=="ماربین وسطی" | dehestan=="ابریشم" | dehestan=="گرکن شمالی" | (ostan=="اصفهان" & dehestan=="نورآباد") |  dehestan=="کرارج" | */ (ostan=="یزد" & dehestan=="کوشک") | dehestan=="رباطات" | dehestan=="مبارکه" | dehestan=="یزدان آباد" | dehestan=="جوزم" | dehestan=="مدوارات" | dehestan=="سرچشمه" | dehestan=="پاقلعه" | dehestan=="پاریز" | (ostan=="کرمان" & dehestan=="شریف آباد") | dehestan=="پایین خواف"

replace treat=0 if treat!=1 & (county_code90==919 | county_code90==804 | county_code90==806 | county_code90==811 | county_code90==412 | county_code90==324 | county_code90==2102 | county_code90==1205 | county_code90==1909) //(shahrestan=="تکاب" | shahrestan=="ورزقان" | shahrestan=="ماهنشان" | shahrestan=="خواف" | shahrestan=="سیرجان" | shahrestan=="راور" | shahrestan=="بافق" | shahrestan=="رفسنجان" | /*shahrestan=="مبارکه" | shahrestan=="تیران وکرون" |*/ shahrestan=="قروه")
tab crop state_code  if treat==1
*/


/// تعیین دهستان‌های شاهد و تیمار جدید
merge m:m treat_match using treat_dehestan.dta
gen treat=1 if _merge==3 
replace treat=0 if treat!=1
keep if _merge==3 | _merge==1
drop _merge 

/////تعداد مشاهدات شاهد و تیمار در هر سال

keep if crop==104 //crop==102 

label define trt_lbl 0 "شاهد" 1 "تیمار"
label values treat trt_lbl

label define yr_lbl 1379 "79" 1380 "80" 1381 "81" 1382 "82" 1383 "83" 1384 "84" 1385 "85" 1386 "86" 1387 "87" 1388 "88" 1389 "89" 1390 "90" 1391 "91" 1392 "92" 1393 "93" 1394 "94" 1395 "95" 1396 "96" 1397 "97"
label values year yr_lbl

gen labelost = "مرکزی" if state_code==00
replace labelost = "گیلان" if state_code==01
replace labelost = "مازندران" if state_code==02
replace labelost = "آذربایجان شرقی" if state_code==03
replace labelost = "آذربایجان غربی" if state_code==04
replace labelost = "کرمانشاه" if state_code==05
replace labelost = "خوزستان" if state_code==06
replace labelost = "فارس" if state_code==07
replace labelost = "کرمان" if state_code==08
replace labelost = "خراسان رضوی" if state_code==09
replace labelost = "اصفهان" if state_code==10
replace labelost = "سیستان و بلوچستان" if state_code==11
replace labelost = "کردستان" if state_code==12
replace labelost = "همدان" if state_code==13
replace labelost = "چهارمحال و بختیاری" if state_code==14
replace labelost = "لرستان" if state_code==15
replace labelost = "ایلام" if state_code==16
replace labelost = "کهگیلویه و بویراحمد" if state_code==17
replace labelost = "بوشهر" if state_code==18
replace labelost = "زنجان" if state_code==19
replace labelost = "سمنان" if state_code==20
replace labelost = "یزد" if state_code==21
replace labelost = "هرمزگان" if state_code==22
replace labelost = "تهران" if state_code==23
replace labelost = "اردبیل" if state_code==24
replace labelost = "قم" if state_code==25
replace labelost = "قزوین" if state_code==26
replace labelost = "گلستان" if state_code==27
replace labelost = "خراسان شمالی" if state_code==28
replace labelost = "خراسان جنوبی" if state_code==29
replace labelost = "البرز" if state_code==30
labmask state_code, values(labelost)

tab treat year, matcell(yr_lbl)
putdocx begin
putdocx table khar =  matrix(yr_lbl), rownames colnames
putdocx table khar(.,20), addcols(1)
putdocx table khar(1,21) = ("مجموع")

forvalues i=0/1 {
 local rlbl: label (treat) `i'
 local row = `i' + 2
 putdocx table khar(`row',1) = (`"`rlbl'"')

 forvalues j=79/97 {
	local clbl: label (year) `j'
	local cstart = `j' - 77
	putdocx table khar(1,`cstart') = (`"`clbl'"')
	local freq`row'_val = yr_lbl[`i'+1,`j'-78]
	local cumul_freq`row' = `cumul_freq`row'' + `freq`row'_val'
	putdocx table khar(`row',21) = ("`cumul_freq`row''")
	}
}///error

putdocx table khar(1,.), addrows(1,before)
putdocx table khar(1,1)= ("تعداد مشاهدات شاهد و تیمار در هر سال"), colspan(21) halign(center) border(left,nil) border(top,nil) border(right,nil)
putdocx table khar(2,1)= ("گروه")
putdocx save exam, replace

//// تعداد شاهد و تیمار در شهرستان‌ها
gen cnty_lbl = "تکاب" if county_code90==412
replace cnty_lbl = "اهر" if county_code90==302
replace cnty_lbl = "ورزقان" if county_code90==324 
replace cnty_lbl = "ماهنشان" if county_code90==1909
replace cnty_lbl = "خواف" if county_code90==919
replace cnty_lbl = "سیرجان" if county_code90==806
replace cnty_lbl = "زرند" if county_code90==805
replace cnty_lbl = "شهربابک" if county_code90==807
replace cnty_lbl = "راور" if county_code90==811
replace cnty_lbl = "بافق" if county_code90==2102
replace cnty_lbl = "اردکان" if county_code90==2101
replace cnty_lbl = "رفسنجان" if county_code90==804
replace cnty_lbl = "قروه" if county_code90==1205
labmask county_code90, values(cnty_lbl)

tab treat county_code90, matcell(cnty_lbl)
putdocx begin
putdocx table tb2 =  matrix(cnty_lbl), rownames colnames
putdocx table tb2(.,14), addcols(1)
putdocx table tb2(1,15) = ("مجموع")

forvalues i=0/1 {
 local rlbl: label (treat) `i'
 local row = `i' + 2
 putdocx table tb2(`row',1) = (`"`rlbl'"')
 local jj=1
 local cumul_freq`row' =0
 foreach j of numlist 412 324 1909 919 806 811 2102 804 1205 805 807 2101 302{
	local clbl: label (county_code90) `j'
	local cstart = `jj' + 1
	putdocx table tb2(1,`cstart') = (`"`clbl'"')
	local freq`row'_val = cnty_lbl[`i'+1,`jj']
	local cumul_freq`row' = `cumul_freq`row'' + `freq`row'_val'
	putdocx table tb2(`row',15) = ("`cumul_freq`row''")
	local jj = `jj' + 1
	}
}

putdocx table tb2(1,.), addrows(1,before)
putdocx table tb2(1,1)= (" تیمار در شهرستان‌های دارای معدن شاخص"), colspan(15) halign(center) border(left,nil) border(top,nil) border(right,nil)
putdocx table tb2(2,1)= ("گروه")
putdocx save exam, append

/////trim data
drop if fland==0
drop if production==0
gen yeild = production/fland
gen ln_yeild = log10(yeild)
gen ln_land = log10(fland+1)
gen ln_production = log10(production+1)
sum yeild, detail
scalar lower = r(p1)
scalar upper = r(p99)
keep if yeild>lower & yeild<upper
gen irr_lbl = "کشت آبی" if irr==1
replace irr_lbl = "کشت دیم" if irr==0
labmask irr, values(irr_lbl)
/////


histogram yeild, percent fcolor(ltblue) lcolor(bluishgray) normal ytitle(درصد) xtitle(لگاریتم مساحت زمین (هکتار)) title(هیستوگرام مساحت زمین‌های تحت کشت گندم (هکتار))

histogram ln_land, percent fcolor(ltblue) lcolor(bluishgray) normal ytitle(درصد) xtitle(لگاریتم مساحت زمین (هکتار)) title(هیستوگرام مساحت زمین‌های تحت کشت گندم (هکتار))

histogram ln_production, percent fcolor(ltblue) lcolor(bluishgray) normal ytitle(درصد) xtitle(گندم تولید شده (کیلوگرم)) by(treat, legend(off) title(هیستوگرام میزان تولید گندم کشاورزان (کیلوگرم)))

twoway kdensity ln_yeild if treat, xtitle(لگاریتم بازده تولید گندم  (لگاریتم کیلوگرم بر هکتار)) ytitle(چگالی احتمال) || kdensity ln_yeild if !treat, legend(order(1 "گروه تیمار" 2 "گروه شاهد")) by(irr) 
graph export ln_yield.png, replace

twoway kdensity ln_yeild if treat & !irr, xtitle(لگاریتم بازده تولید گندم  (لگاریتم کیلوگرم بر هکتار)) ytitle(چگالی احتمال) title(بازده تولید گندم دیم (لگاریتم کیلوگرم بر هکتار)) || kdensity ln_yeild if !treat & !irr, legend(order(1 "گروه تیمار" 2 "گروه شاهد")) 
graph export ln_yield_noirr.png, replace

twoway kdensity ln_production if treat & irr, xscale(range(0,7.5)) xtitle(لگاریتم گندم تولید شده (لگاریتم کیلوگرم)) ytitle(چگالی احتمال) title(میزان تولید گندم آبی (لگاریتم کیلوگرم)) || kdensity ln_production if !treat & irr, legend(order(1 "گروه تیمار" 2 "گروه شاهد")) xscale(range(0,7.5))
graph export ln_production_irr.png, replace

twoway kdensity ln_production if treat & !irr, xscale(range(0,7.5)) xtitle(لگاریتم گندم تولید شده (لگاریتم کیلوگرم)) ytitle(چگالی احتمال) title(میزان تولید گندم دیم (لگاریتم کیلوگرم)) || kdensity ln_production if !treat & !irr, legend(order(1 "گروه تیمار" 2 "گروه شاهد")) xscale(range(0,7.5))
graph export ln_production_noirr.png, replace

ttest ln_yeild if !irr, by(treat)
ttest fland if !irr, by(treat)

////parallel trend
merge m:m treat_match using treat_dehestan_copper.dta
gen treat_copper=1 if _merge==3
replace treat_copper=0 if _merge==1 
destring year_strt, replace
by ostan_code, sort: egen year_strt1 = mean(year_strt)
keep if _merge==3 | _merge==1
drop _merge 
destring year_strt, replace

gen relative_year = year-year_strt1

preserve
collapse (mean) production, by(relative_year treat_copper irr)
line production relative_year if treat_copper==1, xtitle(بررسی فرض روندهای موازی برای معادن مس) ytitle(تولید گندم (کیلوگرم)) || line production relative_year if treat_copper==0 ,legend(order(1 "گروه تیمار" 2 "گروه شاهد")) xline(0) by(irr)
graph export parallel_production_copper.png, replace
restore

preserve
collapse (mean) fland, by(relative_year treat_copper irr)
line fland relative_year if treat_copper==1, xtitle(بررسی فرض روندهای موازی برای معادن مس) ytitle(مساحت مزرعه (هکتار))|| line fland relative_year if treat_copper==0 ,legend(order(1 "گروه تیمار" 2 "گروه شاهد")) xline(0) by(irr) 
graph export parallel_land_copper.png, replace
restore

preserve
collapse (mean) yeild, by(relative_year treat_copper irr)
line yeild relative_year if treat_copper==1, xtitle(بررسی فرض روندهای موازی برای معادن مس) ytitle(بازده تولید گندم (کیلوگرم بر هکتار))|| line yeild relative_year if treat_copper==0 ,legend(order(1 "گروه تیمار" 2 "گروه شاهد")) xline(0) by(irr) 
graph export parallel_yield_copper.png, replace
restore

preserve
collapse (mean) yeild, by(relative_year treat_copper irr)
line yeild relative_year if treat==1, xtitle(بررسی فرض روندهای موازی برای معادن مس) ytitle(بازده تولید گندم (کیلوگرم بر هکتار))|| line yeild relative_year if treat==0 ,legend(order(1 "گروه تیمار" 2 "گروه شاهد")) xline(0) by(irr) 
graph export parallel_yield_copper.png, replace
restore