

global datadir "D:\Datasets\US Census\jt_laws\"
global inputfile "$datadir\state_age_limits_1850_1950_13may2025_JT.dta"
global outputfile "$datadir\cohort_requirements_13may2025_JT.dta"

 
log query
if length("`r(status)'") > 0 {
	log close
}
log using temp, replace

clear
set more off
set memory 1000m
set matsize 800

* Calculate years of required attendance by bith cohort, for the census data

use "$inputfile", clear

* Fill in 99 and 99X variables
replace earlyyrs = 4 if earlyyrs == 99
replace earlyyrs = 10 if earlyyrs == 9910
replace earlyyrs = 8 if earlyyrs == 998
replace earlyyrs = 7 if earlyyrs == 997
replace earlyyrs = 6 if earlyyrs == 996

replace workyrs = 4 if workyrs == 99
replace workyrs = 10 if workyrs == 9910
replace workyrs = 8 if workyrs == 998
replace workyrs = 7 if workyrs == 997
replace workyrs = 6 if workyrs == 996

replace contyrs = 4 if contyrs == 99
replace contyrs = 10 if contyrs == 9910
replace contyrs = 8 if contyrs == 998
replace contyrs = 7 if contyrs == 997
replace contyrs = 6 if contyrs == 996

tab entryage
tab exitage
tab earlyyrs
tab earlyyrs_condition
tab workage
tab workyrs
tab contage
tab contyrs

** Begin iterative calculation of the laws
qui sum year
local counter = `r(N)' + 1

gen birthyear = .
foreach num of numlist 1835/1945 {
set obs `counter'
replace birthyear = `num' in `counter'
local counter = `counter' + 1
}

fillin birthyear statefip
sort statefip birthyear
drop _fillin
gen exempt_yearstodropout = 0 if !missing(birthyear)
gen exempt_workpermit = 0 if !missing(birthyear)
gen exempt_cont = 0 if !missing(birthyear)
* Accounting only for entry age and exitage
gen ca_years1 = 0 if !missing(birthyear)
* Accounting for workyrs and workage
gen ca_years2 = 0 if !missing(birthyear)
* Accounting for earlyyrs and earlyyrs_condition
gen ca_years3 = 0 if !missing(birthyear)
* Additional years of continuation school above workage and workyrs
gen ca_years4 = 0 if !missing(birthyear)


 foreach state of numlist 1 4 5 6 8 9 10 11 12 13 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56  {

	foreach birthyear of numlist 1835/1945 {
	
		foreach age of numlist 5/18 {
			local myyear = `birthyear' + `age'
			di "State " `state'
			di "Birthyear " `birthyear'
** Grab each law for given state and year
				qui mean entryage if statefip == `state' & year == `myyear'
				matrix temp = e(b)
				local thisentryage = temp[1,1]

				qui mean exitage if statefip == `state' & year == `myyear'
				matrix temp = e(b)
				local thisexitage = temp[1,1]
				
				/*
				qui mean earlyyrs if statefip == `state' & year == `myyear'
				matrix temp = e(b)
				local thisearlyyrs = temp[1,1]
				
				qui mean earlyyrs_condition if statefip == `state' & year == `myyear'
				matrix temp = e(b)
				local thisearlyyrs_condition = temp[1,1]

				qui mean workage if statefip == `state' & year == `myyear'
				matrix temp = e(b)
				local thisworkage = temp[1,1]

				qui mean workyrs if statefip == `state' & year == `myyear'
				matrix temp = e(b)
				local thisworkyrs = temp[1,1]

				qui mean contage if statefip == `state' & year == `myyear'
				matrix temp = e(b)
				local thiscontage = temp[1,1]

				qui mean contyrs if statefip == `state' & year == `myyear'
				matrix temp = e(b)
				local thiscontyrs = temp[1,1]
				*/

* Calculate whether exemptions applied
	
				/*
				replace exempt_workpermit = ca_years2 >= `thisworkyrs' & `age' >= `thisworkage' & `thisworkage' > 0 if statefip == `state' & birthyear == `birthyear'

				replace exempt_yearstodropout = ca_years3 >= `thisearlyyrs' & `age' >= `thisearlyyrs_condition' & `thisearlyyrs' > 0 if statefip == `state' & birthyear == `birthyear'

				replace exempt_cont = (ca_years2 + ca_years4) >= `thiscontyrs' & `thiscontyrs' > 0 if statefip == `state' & birthyear == `birthyear'
				*/

* Increment each law when school is required

				replace ca_years1 = ca_years1 + 1 if statefip == `state' & birthyear == `birthyear' & `age' >= `thisentryage' & `age' < `thisexitage'  
	
				/*
				replace ca_years2 = ca_years2 + 1 if statefip == `state' & birthyear == `birthyear' & `age' >= `thisentryage' & `age' < `thisexitage' & !exempt_workpermit 

				replace ca_years3 = ca_years3 + 1 if statefip == `state' & birthyear == `birthyear' & `age' >= `thisentryage' & `age' < `thisexitage' & !exempt_yearstodropout 

				replace ca_years4 = ca_years4 + 1 if statefip == `state' & birthyear == `birthyear' & `age' >= `thisworkage' & `age' < `thiscontage' & !exempt_cont & `thisworkage' > 0 & !(`age' >= `thisentryage' & `age' < `thisexitage' & !exempt_workpermit)
				*/
		}
	}
	list statename ca* if birthyear == 1900 & statefip == `state'
}

sort statefip year
rename birthyear yob
gen bpl = statefip

drop if missing(bpl)
drop if missing(yob)

/*
egen ca_years = rmin(ca_years2 ca_years3)
gen ca_years5 = ca_years2 + ca_years4
egen ca_years_combined = rmin(ca_years3 ca_years5)
*/

drop exempt_cont exempt_workpermit exempt_yearstodropout reference_courseofstudy reference_agelimit contyrs contage workyrs workage earlyyrs earlyyrs_condition exitage entryage year



replace statename = "."				
replace statename = 	"	Alabama	"		 if bpl == 	1
replace statename = 	"	Arizona	"		 if bpl == 	4
replace statename = 	"	Alaska	"		 if bpl == 	2
replace statename = 	"	Arkansas	"		 if bpl == 	5
replace statename = 	"	California	"		 if bpl == 	6
replace statename = 	"	Colorado	"		 if bpl == 	8
replace statename = 	"	Connecticut	"		 if bpl == 	9
replace statename = 	"	Delaware	"		 if bpl == 	10
replace statename = 	"	District of Columbia	"		 if bpl == 	11
replace statename = 	"	Florida	"		 if bpl == 	12
replace statename = 	"	Georgia	"		 if bpl == 	13
replace statename = 	"	Idaho	"		 if bpl == 	16
replace statename = 	"	Illinois	"		 if bpl == 	17
replace statename = 	"	Indiana	"		 if bpl == 	18
replace statename = 	"	Iowa	"		 if bpl == 	19
replace statename = 	"	Kansas	"		 if bpl == 	20
replace statename = 	"	Kentucky	"		 if bpl == 	21
replace statename = 	"	Louisiana	"		 if bpl == 	22
replace statename = 	"	Maine	"		 if bpl == 	23
replace statename = 	"	Maryland	"		 if bpl == 	24
replace statename = 	"	Massachusetts	"		 if bpl == 	25
replace statename = 	"	Michigan	"		 if bpl == 	26
replace statename = 	"	Minnesota	"		 if bpl == 	27
replace statename = 	"	Mississippi	"		 if bpl == 	28
replace statename = 	"	Missouri	"		 if bpl == 	29
replace statename = 	"	Montana	"		 if bpl == 	30
replace statename = 	"	Nebraska	"		 if bpl == 	31
replace statename = 	"	Nevada	"		 if bpl == 	32
replace statename = 	"	New Hampshire	"		 if bpl == 	33
replace statename = 	"	New Jersey	"		 if bpl == 	34
replace statename = 	"	New Mexico	"		 if bpl == 	35
replace statename = 	"	New York	"		 if bpl == 	36
replace statename = 	"	North Carolina	"		 if bpl == 	37
replace statename = 	"	North Dakota	"		 if bpl == 	38
replace statename = 	"	Ohio	"		 if bpl == 	39
replace statename = 	"	Oklahoma	"		 if bpl == 	40
replace statename = 	"	Oregon 	"		 if bpl == 	41
replace statename = 	"	Pennsylvania	"		 if bpl == 	42
replace statename = 	"	Rhode Island	"		 if bpl == 	44
replace statename = 	"	South Carolina	"		 if bpl == 	45
replace statename = 	"	South Dakota	"		 if bpl == 	46
replace statename = 	"	Tennessee	"		 if bpl == 	47
replace statename = 	"	Texas	"		 if bpl == 	48
replace statename = 	"	Utah	"		 if bpl == 	49
replace statename = 	"	Vermont	"		 if bpl == 	50
replace statename = 	"	Virginia	"		 if bpl == 	51
replace statename = 	"	Washington	"		 if bpl == 	53
replace statename = 	"	West Virginia	"		 if bpl == 	54
replace statename = 	"	Wisconsin	"		 if bpl == 	55
replace statename = 	"	Wyoming	"		 if bpl == 	56


replace statename = trim(statename)



gen region = .
replace region = 	1 if bpl == 42
replace region = 	1 if bpl == 36
replace region = 	1 if bpl == 23
replace region =    1 if bpl == 9		
replace region = 	1 if bpl == 25
replace region = 	1 if bpl == 50
replace region = 	1 if bpl == 24
replace region = 	1 if bpl == 11
replace region = 	1 if bpl == 33
replace region = 	1 if bpl == 10
replace region = 	1 if bpl == 34
replace region = 	1 if bpl == 44
replace region = 	2 if bpl == 54
replace region = 	2 if bpl == 27
replace region = 	2 if bpl == 19
replace region = 	2 if bpl == 29
replace region = 	2 if bpl == 46
replace region = 	2 if bpl == 31
replace region = 	2 if bpl == 38
replace region = 	2 if bpl == 39
replace region = 	2 if bpl == 55
replace region = 	2 if bpl == 18
replace region = 	2 if bpl == 21
replace region = 	2 if bpl == 26
replace region = 	2 if bpl == 17
replace region = 	2 if bpl == 20
replace region = 	3 if bpl == 48
replace region = 	3 if bpl == 22
replace region = 	3 if bpl == 51
replace region = 	3 if bpl == 28
replace region =    3 if bpl == 1		
replace region = 	3 if bpl == 12
replace region =    3 if bpl == 5		
replace region = 	3 if bpl == 45
replace region = 	3 if bpl == 13
replace region = 	3 if bpl == 47
replace region = 	3 if bpl == 37
replace region = 	4 if bpl == 40
replace region = 	4 if bpl == 53
replace region = 	4 if bpl == 30
replace region = 	4 if bpl == 35
replace region = 	4 if bpl == 41
replace region =    4 if bpl == 8		
replace region = 	4 if bpl == 32
replace region = 	4 if bpl == 49
replace region = 	4 if bpl == 16
replace region = 4 if bpl == 4		
replace region = 4 if bpl == 6		
replace region = 	4 if bpl == 56

keep yob bpl ca_years* region statename statefip

drop ca_years2 ca_years3 ca_years4

order statename statefip bpl region yob ca_years1 //ca_years2 ca_years3 ca_years4 ca_years5 ca_years ca_years_combined
sort bpl yob 

* Create an indicator saying how many states (percentage) have passed ANY compulsory schooling law
gen law_binary = .
replace law_binary = 1 if ca_years1 > 0
replace law_binary = 0 if ca_years1 == 0
bysort yob: egen law_binary_mean = mean(law_binary)

* Create an indicator for the first year a state had passed
gen first_cohort_test = .
replace first_cohort_test = yob if ca_years1 > 0 & ca_years1[_n-1] == 0
egen first_cohort = min(first_cohort_test), by(bpl)

drop first_cohort_test

save "$outputfile", replace

log close

* view temp.smcl
* do state_graphs.do



