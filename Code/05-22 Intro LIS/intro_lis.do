cd "C:\Users\julien.blasco\Documents\pfe-liepp\Code\05-22 Intro LIS"
use "us04ih.dta", clear
sum dhi, de
keep dhi hpopwgt nhhmem grossnet factor hitsi hitsu hitsa hitp hxit

gen miss_comp = 0
replace miss_comp = 1 if mi(dhi) | mi(hpopwgt) | mi(nhhmem) ///
					| mi(grossnet ) | mi(factor) | mi(hitsi) ///
					| mi(hitsu) | mi(hitsa) | mi(hitp) | mi(hxit)
tabulate miss_comp					

sum grossnet

// Top and bottom coding
gen dhi_tb = dhi
replace dhi_tb = 0 if dhi_tb<0
quietly sum dhi,de
replace dhi_tb = 10*r(p50) if dhi_tb>10*r(p50)

// Equivalising
gen edhi_tb = dhi_tb/sqrt(nhhmem)

// Per-capita income
gen pcdhi_tb = dhi_tb/nhhmem

sum dhi dhi_ edh pcdh
