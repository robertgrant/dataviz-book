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


set seed 88019

clear
set obs 20
gen train=(_n<11)
gen x=rnormal(10,1)
gen y=x+rnormal(0,0.6)
gen preds=0
sort x
tempfile working
save "`working'", replace
clear
set obs 401
gen x=8+((_n-1)/100)
gen y=.
gen preds=1
append using "`working'"

twoway (scatter y x if train==1, mcol(navy) ytitle("") xtitle("")), ///
		name(train, replace) legend(off) graphregion(color(white)) caption("Training set.")
graph export "CV-train.svg", replace
graph export "CV-train.png", replace
twoway (scatter y x if train==0, mcol(navy) ytitle("") xtitle("")), ///
		name(test, replace) legend(off) graphregion(color(white)) caption("Test set.")
graph export "CV-test.svg", replace
graph export "CV-test.png", replace

// simple regression
regress y x if train==1
predict xb_simple
gen sqerror_simple=(xb_simple-y)^2
// training plot
qui summ sqerror_simple if train==1
local rmse_simple=r(mean)
local rmse_simple: dis %8.2f sqrt(`rmse_simple')
twoway (scatter y x if train==1, mcol(navy) ytitle("") xtitle("")) ///
		(line xb_simple x if preds==1, lcol(dkorange)) ///
		(scatter xb_simple x if train==1, msymbol(Oh) mcol(dkorange)) ///
		(rspike y xb_simple x if train==1, lcol(dkorange) lpattern(dash)), ///
		name(simple_train, replace) legend(off) graphregion(color(white)) caption("Training set. RMS error: `rmse_simple'")
graph export "CV-simple-train.svg", replace
graph export "CV-simple-train.png", replace
// test plot
qui summ sqerror_simple if train==0
local rmse_simple=r(mean)
local rmse_simple: dis %8.2f sqrt(`rmse_simple')
twoway (scatter y x if train==0, mcol(navy) ytitle("") xtitle("")) ///
		(line xb_simple x if preds==1, lcol(dkorange)) ///
		(scatter xb_simple x if train==0, msymbol(Oh) mcol(dkorange)) ///
		(rspike y xb_simple x if train==0, lcol(dkorange) lpattern(dash)), ///
		name(simple_test, replace) legend(off) graphregion(color(white)) caption("Test set. RMS error: `rmse_simple'")
graph export "CV-simple-test.svg", replace
graph export "CV-simple-test.png", replace

// complex regression
gen x2=x^2
gen x3=x^3
gen x4=x^4
gen sinx=sin(x)
gen cosx=cos(x)
gen sin2x=sin(2*x)
gen cos2x=cos(2*x)
regress y x x2 x3 x4 sinx cosx sin2x cos2x if train==1
predict xb_complex
gen sqerror_complex=(xb_complex-y)^2
// training plot
qui summ sqerror_complex if train==1
local rmse_complex=r(mean)
local rmse_complex: dis %8.2f sqrt(`rmse_complex')
twoway (scatter y x if train==1, mcol(navy) ytitle("") xtitle("")) ///
		(line xb_complex x if preds==1, lcol(dkorange)) ///
		(scatter xb_complex x if train==1, msymbol(Oh) mcol(dkorange)) ///
		(rspike y xb_complex x if train==1, lcol(dkorange) lpattern(dash)), ///
		name(complex_train, replace) legend(off) graphregion(color(white)) caption("Training set. RMS error: `rmse_complex'")
graph export "CV-complex-train.svg", replace
graph export "CV-complex-train.png", replace
// test plot
qui summ sqerror_complex if train==0
local rmse_complex=r(mean)
local rmse_complex: dis %8.2f sqrt(`rmse_complex')
twoway (scatter y x if train==0, mcol(navy) ytitle("") xtitle("")) ///
		(line xb_complex x if preds==1, lcol(dkorange)) ///
		(scatter xb_complex x if train==0, msymbol(Oh) mcol(dkorange)) ///
		(rspike y xb_complex x if train==0, lcol(dkorange) lpattern(dash)), ///
		name(complex_test, replace) legend(off) graphregion(color(white)) caption("Test set. RMS error: `rmse_complex'")
graph export "CV-complex-test.svg", replace
graph export "CV-complex-test.png", replace
twoway (scatter y x if train==0 & x>8.5 & x<11.8, mcol(navy) ytitle("") xtitle("")) ///
		(line xb_complex x if preds==1 & x>8.5 & x<11.8, lcol(dkorange)) ///
		(scatter xb_complex x if train==0 & x>8.5 & x<11.8, msymbol(Oh) mcol(dkorange)) ///
		(rspike y xb_complex x if train==0 & x>8.5 & x<11.8, lcol(dkorange) lpattern(dash)), ///
		name(complex_test_zoomed, replace) legend(off) graphregion(color(white)) caption("Test set. RMS error: `rmse_complex'")
graph export "CV-complex-test-zoomed.svg", replace
graph export "CV-complex-test-zoomed.png", replace

graph combine simple_train simple_test, rows(1) graphregion(color(white))
graph export "CV-simple.svg", replace
graph export "CV-simple.png", replace

graph combine complex_train complex_test complex_test_zoomed, rows(2) cols(2) graphregion(color(white))
graph export "CV-complex.svg", replace
graph export "CV-complex.png", replace
