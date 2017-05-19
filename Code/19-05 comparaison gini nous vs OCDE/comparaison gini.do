// First graphs
use "C:\Users\Julien\Documents\-- PFE\base pour julien 19 mai.dta", clear
graph dot (mean) inc2_gini, over(country) by(year)
graph export "C:\Users\Julien\Documents\-- PFE\gini_pretax_ours_all_pop.pdf", as(pdf) replace

import delimited "C:\Users\Julien\Documents\-- PFE\ocde_data_gini.csv", delimiter(";") varnames(1) clear 
reshape long year, i(name code) j(annee)
rename year gini
graph dot (mean) gini, over(name) by(annee)
graph export "C:\Users\Julien\Documents\-- PFE\gini_pretax ocde_working_pop.pdf", as(pdf) replace

// Merge both databases and sort by gini on ours

