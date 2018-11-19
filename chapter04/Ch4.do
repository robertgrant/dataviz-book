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

// Chapter 4

// Fig 4.1

clear all
set obs 100
gen shop=0
replace shop=1 in 1/71
gen index=1
label var shop "Do you use online grocery shopping?"
label define binlab 0 "No" 1 "Yes"
label values shop binlab
graph bar (percent) index, over(shop) yscale(range(0 100)) ylabel(0(20)100) ytick(0(10)100, grid) ///
	graphregion(color(white)) ytitle("Do you use online grocery shopping? (%)") bar(1, color(gs7)) bar(2, color(gs7))
graph export "3-bar-binary.svg", replace
// manual edit in Inkscape follows to include bullet chart alongside


// Figure 4.4

clear all
set obs 1
gen tw=100*60/180
gen fb=100*140/195
graph bar tw fb, legend(order(1 "SnapFace" 2 "Linkbook")) yscale(range(0 100)) ///
     ylabel(0(10)100) ytitle ("% of respondents who use social media:") ///
	 graphregion(color(white)) bar(1, color(black) fcolor(gs4)) ///
	 bar(2, color(black) fcolor(gs12)) bargap(20)
graph export "3-bar-compare-questions.svg", replace
graph export "3-bar-compare-questions.png", replace



// Figure 4.6, in two parts
clear all
set obs 6
gen time=2010
replace time=2015 in 4/6
gen use=33.333
replace use=29.1 in 4
replace use=71.79 in 2
replace use=74.8 in 5
replace use=18.1 in 3
replace use=20.9 in 6
gen str12 platform="CheepCheep"
replace platform="Linkchat" in 2
replace platform="Linkchat" in 5
replace platform="MyFace" in 3
replace platform="MyFace" in 6
graph hbar use, over(time) over(platform) graphregion(color(white)) ///
     yscale(range(0 100)) ylabel(0(10)100) ///
	 ytitle ("% of respondents who use:") ///
	 legend(order(1 "CheepCheep" 2 "Linkchat" 3 "MyFace")) ///
	 bar(1, color(gs2) fcolor(gs2)) bar(2, color(gs8) fcolor(gs8)) ///
	 bar(3, color(gs14) fcolor(gs14)) bargap(12) title("Customers' social media use")
graph export "3-bar-compare-time1.svg", replace
graph export "3-bar-compare-time1.png", replace
graph hbar use, over(platform) over(time) graphregion(color(white)) ///
     yscale(range(0 100)) ylabel(0(10)100) ///
	 ytitle ("% of respondents who use:") ///
	 bar(1, color(gs2) fcolor(gs2)) bar(2, color(gs8) fcolor(gs8)) ///
	 bar(3, color(gs14) fcolor(gs14)) bargap(12) title("Customers' social media use")
graph export "3-bar-compare-time2.svg", replace
graph export "3-bar-compare-time2.png", replace

// Figure 4.5
encode platform, gen(nplat)
drop platform
reshape wide use, i(time) j(nplat)
graph bar use*, over(time) stack bar(1, color(navy)) bar(2, color(dkorange)) bar(3, color(black)) ///
	graphregion(color(white)) title("Customers' social media use") ///
	legend(order(1 "CheepCheep" 2 "Linkchat" 3 "MyFace"))
graph export "3-bar-stacked.svg", replace
graph export "3-bar-stacked.png", replace
