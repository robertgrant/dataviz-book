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


/*

NYC 2013 taxi data
(all 173 million journeys made in 2013)
Example of Stata for "big data" processing

These are the variable names and example data from
the trip_data_*.csv files:

medallion				3418135604CD3F357DD9577AF978C5C0
hack_license			B25386A1F259C87449430593E904FDBC
vendor_id				VTS
rate_code				1
store_and_fwd_flag		N
pickup_datetime			30/08/2013 07:57
dropoff_datetime		30/08/2013 08:30
passenger_count			5
trip_time_in_secs		1980
trip_distance			14.58
pickup_longitude		-73.791359
pickup_latitude			40.645657
dropoff_longitude		-73.922501
dropoff_latitude		40.758766

Working on a fairly typical desktop PC (64-bit Windows,
2-core 3GHz processor, 3GB RAM), Excel cannot open even the
smallest trip_data file (August, 2.05GB).

In fact, the key to Big Data processing is that, regardless
of computing power available, one NEVER benefits from opening
the whole file but rather looping intelligently through smaller
packets and pooling the results in a manageable way.

*/

version 13.1

// If we need to examine the format of the file without opening it:
file open taxidata using "trip_data_1.csv", read text
forvalues i=1/5 {
	file read taxidata line
	dis as result "Line `i': `macval(line)'"
}
file close taxidata

// Now read in the first 100,000 lines
import delimited "trip_data_1.csv", delimiters(",") varnames(1) ///
	rowrange(100001:200000) clear

// extract the pick-up time
generate hstring=substr(pickup_datetime,12,2)
generate mstring=substr(pickup_datetime,15,2)
destring hstring, gen(h)
destring mstring, gen(min)
replace h=round(h+(min/60),0.1)

// remove any digital rounding error
generate correction=mod(h+0.03,0.1)
generate hour=h-correction+0.03
replace hour=0 if hour<0.001

// extract distance in tenths of miles
generate int miles=round(trip_distance,0.1)

// collapse to a count in each combination of these
generate temp=1
collapse (count) trips=temp, by(miles hour) fast

// save this
save "taxis.dta", replace

// Now we can define the above as a program
capture program drop gettaxi
program define gettaxi, rclass
	version 13.1
	args month firstrow lastrow
	import delimited "trip_data_`month'.csv", delimiters(",") varnames(1) ///
		rowrange(`firstrow':`lastrow') clear
	qui count
	local nrows=r(N) // monitor number of rows obtained
	generate hstring=substr(pickup_datetime,12,2)
	generate mstring=substr(pickup_datetime,15,2)
	destring hstring, gen(h)
	destring mstring, gen(min)
	replace h=round(h+(min/60),0.1)
	generate correction=mod(h+0.03,0.1)
	generate hour=h-correction+0.03
	replace hour=0 if hour<0.001
	generate int miles=round(trip_distance,0.1)
	generate temp=1
	if `firstrow'>1 {
		collapse (count) trips2=temp, by(miles hour) fast
		merge 1:1 miles hour using "taxis.dta"
		replace trips=0 if trips==.
		replace trips2=0 if trips==.
		replace trips=trips+trips2
		drop trips2
		drop _merge
	}
	else {
		collapse (count) trips=temp, by(miles hour) fast
	}
	save "taxis.dta", replace
	return local nrows=`nrows'
end

/* and if we type:
	gettaxi 2 500001 600000
   it will open the February (2) file and fetch rows 500,001-600,000.
   If the file stops before 600,000 we will get rows up to the end,
   so we can use this to spot when we reach the end.
   This program adds the count of trips to the taxis.dta file.
*/

// A loop to fetch all the data for January
display c(current_time)
local frow=1
local lrow=1000000 // starting row numbers
local step=`lrow'-`frow'+1
local obt=`lrow' // to monitor how many are obtained
while `obt'==`step' | (`obt'==`step'-1 & `frow'==`step'+1) {
	dis as result "Now fetching rows `frow' to `lrow'"
	gettaxi 1 `frow' `lrow'
	local obt=r(nrows)
	local frow=`lrow'+1
	local lrow=`lrow'+`step'
}
local stoptime=c(current_time)
beep
dis as result "Job completed at `stoptime'!"
