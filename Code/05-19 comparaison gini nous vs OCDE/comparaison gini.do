cd "C:\Users\julien.blasco\Documents\pfe-liepp\Code\19-05 comparaison gini nous vs OCDE"

/***
First graphs with working age pop
***/
use "./base pour julien 19 mai.dta", clear
graph dot (mean) inc1_gini, over(country) by(year)
graph export "./gini_pretax_ours_all_pop.pdf", as(pdf) replace

import delimited "./ocde_data_gini.csv", delimiter(";") varnames(1) clear 
reshape long year, i(name code) j(annee)
rename year gini_ocde
rename name country
rename annee year
graph dot (mean) gini_ocde, over(country) by(year)
graph export "./gini_pretax ocde_working_pop.pdf", as(pdf) replace

/***
Read new OCDE data and generate dta
***/
import delimited ".\ocde_all_pop_before_and_after.csv", clear 
// do some reshaping
keep country year measure methodo value 
bysort country year measure : egen gini=mean(value)
drop value methodo
bysort country year measure : gen dup1=_n
keep if dup1==1
drop dup1
gen ginia=gini if measure=="GINI"
gen ginib=gini if measure=="GINIB"
bysort country year : egen ginia1=mean(ginia)
bysort country year : egen ginib1=mean(ginib)
bysort country year : gen dup=_n
keep if dup==1
drop gini measure ginia ginib dup
rename ginia1 ginia
rename ginib1 ginib
save ".\oecde_all_pop_before_and_after.dta"

/***
Merge both databases and sort by our gini
***/
use "./base pour julien 19 mai.dta", clear
replace year = 2007 in 26 //change date for France 2005
replace year = 2007 in 27 // change date for Sweden 2005

merge 1:1 country year using ".\oecde_all_pop_before_and_after.dta", nogenerate
sort inc1_gini
graph dot (mean) inc2_gini (mean) ginib if year==2007, over(country)
twoway (scatter ginia inc4_gini if year==2010, mlabel(country)) (scatter ginib inc2_gini if year==2010, mlabel(country)) (function y=x, range (0.2 .7))
save "./merged_all_pop.dta"
