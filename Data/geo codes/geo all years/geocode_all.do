/////////////////////compare geo codes for years 81-82/
 
/////////////////////compare geo-codes for years 85-95/////////////////////////
cd "C:\Melika\thesis\data\amar org\geo\geo all years"
forvalues y=76(1)100{
	if(`y'==77 |`y'==78 | `y'==79 | `y'==80 |`y'==86 | `y'==87 | `y'==83 | `y'==84){
		continue
	}
	if(`y'<93){
	import excel using "GEO`y'Xls", describe
	local sh = r(N_worksheet)-2
	display(`y')
		forvalues n=1(1)`sh'{
			 clear
			 if `n'<10 import excel "GEO`y'Xls", sheet("0`n'") cellrange(A4) 
			 if `n'>9 import excel "GEO`y'Xls", sheet("`n'") cellrange(A4) 
			 tempfile d`n'
			 save d`n', replace
		}
		clear
		import excel "GEO`y'Xls", sheet("00") cellrange(A4)
		forvalues n=1(1)`sh'{
			 append using d`n'
		}
	}
	else{
		clear
		import excel "GEO`y'Xls", cellrange(A4)
	}
	rename A code
	if (`y'==88){
		rename B abadi
		rename C dehestan
		rename D shahr
		rename E bakhsh
		rename F shahrestan
		rename G ostan
	}
	else if (`y'>=95){
		rename C ostan
		rename E shahrestan
		rename G bakhsh
		rename I dehestan
		rename M abadi
	}
	else{
		rename B ostan
		rename C shahrestan
		rename D bakhsh
		rename E shahr
		rename F dehestan
		rename G abadi
	}
	gen village = substr(code,14,6) //substr(code,11,6)
	if (`y'>87){
		replace village = substr(code,11,6)
	}
	gen dehestan_code = substr(code,7,4)
	gen bakhsh_code = substr(code,5,2)
	gen shahrestan_code = substr(code,3,2)
	gen ostan_code = substr(code,1,2)
	gen match_code = ostan_code + shahrestan_code + village
	//destring village *_code, replace
	//cd "C:\Melika\thesis\data\agriculture\pourghasem\New folder"
	save geocode`y', replace
	export delimited using "C:\Melika\thesis\data\amar org\geo\geo all years\true village codes of different years\village_code_`y'.csv", replace

}