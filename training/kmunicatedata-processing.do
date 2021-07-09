// reducing KMunicatedata.dta to counts for dataviz

use kmunicatedata.dta, clear

gen temp=1

recode role (2 7 8 = 1) (else = 0), gen(analysis)
label define analysislab 0 No 1 Yes
label values analysis analysislab
label variable analysis "Trained in data analysis?"

rename use_areas_beneath use_lines_beneath
rename use_areasbeneath use_areas_beneath
rename use_areasbehind use_areas_behind
label define uselab 1 "Less useful" 2 "Equal" 3 "More useful"
#delimit ;
local usevars "use_exttable 
               use_lines_beneath 
			   use_areas_beneath 
			   use_areas_behind 
			   use_fading 
			   use_confint";
#delimit cr
foreach v of local usevars {
	recode `v' (3 4 5 = 3) (1=1) (2=2), gen(`v'2)
	drop `v'
	rename `v'2 `v'
	label values `v' uselab
}


#delimit ;
local riskrankvars   "risk_standard_rank 
                      risk_exttable_rank 
					  risk_lines_rank 
					  risk_areasbeneath_rank 
					  risk_areasbehind_rank";
local uncerankvars   "unce_standard_rank 
                      unce_fading_rank 
					  unce_confint_rank";
#delimit cr

egen tempsum=rowtotal(`riskrankvars') 
gen risk_missing=(tempsum<6)
drop tempsum
egen tempsum=rowtotal(`uncerankvars')
gen unce_missing=(tempsum<6)
drop tempsum

save "kmunicatedata_cleaned.dta", replace

collapse (sum) count=temp,  ///
    by(analysis `usevars' `riskrankvars' `uncerankvars')
save "kmunicatedata_count_roles.dta", replace
// these are for image 2:
foreach v of local usevars {
	tab `v' analysis [fw=count], col chi2
}

collapse (sum) count=count, ///
    by(`usevars' `riskrankvars' `uncerankvars')
save "kmunicatedata_count.dta", replace
// these are for image 1:
tab1 `usevars' [fw=count]
// these are for image 3:
tab1 `riskrankvars' `uncerankvars' [fw=count]
