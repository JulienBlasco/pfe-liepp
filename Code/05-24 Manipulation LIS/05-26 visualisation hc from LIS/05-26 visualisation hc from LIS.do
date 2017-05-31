// different datasets are possible
import delimited ".\hc_hceduc_hcmed_qu100_all2010.csv", clear 

// on enlève les premiers pcentiles car Y est trop haut
twoway (scatter hc threshold if quantile>4, msize(vsmall)), by(ccyy, yrescale xrescale)

gen prop = hc/threshold
twoway (scatter prop quantile if quantile>4, msize(vsmall)), by(ccyy, yrescale xrescale)

gen educ_over_total = hceduc/hc
twoway (scatter educ_over_total threshold, msize(vsmall)), by(ccyy, xrescale)

gen health_over_total = hcmed/hc
twoway (scatter health_over_total threshold, msize(vsmall)), by(ccyy, xrescale)


import delimited ".\hcbgiftg_qu100_all2010.csv", clear 
// we can check that hcbgiftg and hncbgiftg are indeed the same variables
list if hcbgiftg!= hncbgiftg

gen gvt_over_total = hcbgiftg/hc
twoway (scatter gvt_over_total threshold, msize(vsmall)), by(ccyy, xrescale)

twoway (scatter hncbgiftg threshold, msize(vsmall)), by(ccyy, xrescale yrescale)

gen educ_over_total = hceduc/hc
twoway (scatter educ_over_total threshold, msize(vsmall)), by(ccyy, xrescale)

gen health_over_total = hcmed/hc
twoway (scatter health_over_total threshold, msize(vsmall)), by(ccyy, xrescale)

	