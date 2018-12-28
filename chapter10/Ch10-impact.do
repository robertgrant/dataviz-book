/*
############################################################################
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>
############################################################################
*/


clear all
use "impact.dta", clear

// data cleaning
label define ethlab2 1 "White ethnicity" 2 "Non-white ethnicity"
label values ethnic ethlab2
gen after=time-los
label var after "Days from discharge to relapse"
gen planned=183
replace planned=91.5 if treat==0 & site==0
replace planned=365 if treat==1 & site==1
gen early=(los<(0.75*planned))
label var early "Left Treatment Early"
label var treat "Longer Treatment"


// adjusted effects
label var treat "Length of Treatment"
logistic relapse i.treat ivhx ndrugtx early i.ethnic

margins i.treat
marginsplot, graphregion(color(white)) title("") ytitle("Risk of relapse") ///
	yscale(range(0 1)) ylabel(0(0.1)1) plotregion(margin(7 7 0 0))
graph export "10-margins-simple.png", replace
graph export "10-margins-simple.svg", replace
margins i.treat, at(ivhx=1)
marginsplot, graphregion(color(white)) title("None") ytitle("Risk of relapse") ///
	yscale(range(0 1)) ylabel(0(0.1)1) plotregion(margin(7 7 0 0)) name(ivhx1, replace)
margins i.treat, at(ivhx=2)
marginsplot, graphregion(color(white)) title("Previous") ytitle("Risk of relapse") ///
	yscale(range(0 1)) ylabel(0(0.1)1) plotregion(margin(7 7 0 0)) name(ivhx2, replace)
margins i.treat, at(ivhx=3)
marginsplot, graphregion(color(white)) title("Recent") ytitle("Risk of relapse") ///
	yscale(range(0 1)) ylabel(0(0.1)1) plotregion(margin(7 7 0 0)) name(ivhx3, replace)
graph combine ivhx1 ivhx2 ivhx3, graphregion(color(white)) rows(1) title("History of addiction treatments:")
graph export "10-margins-at.png", replace
graph export "10-margins-at.svg", replace


coefplot, eform xline(1, lpattern(dash)) drop(_cons) xtitle("Odds ratios") graphregion(color(white))
graph export "10-coefplot.png", replace
graph export "10-coefplot.svg", replace

// survival analysis
replace time=610 if time==.
stset time, failure(relapse)
sts graph, by(treat)
graph export "10-KM.png", replace
graph export "10-KM.svg", replace
