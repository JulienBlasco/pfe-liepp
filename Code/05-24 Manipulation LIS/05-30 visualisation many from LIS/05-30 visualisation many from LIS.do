import delimited "C:\Users\julien.blasco\Documents\pfe-liepp\Code\05-24 Manipulation LIS\manyvar_qu100_manyccy.csv", clear 

tab year

// See if hcmed is the sum of hmcmed and hncmed
replace hncmed=0 if hncmed==.
gen hcmed2 = hmcmed + hncmed
list if hcmed2!=hcmed & hcmed2-hcmed>1

// see who is spending the most in education accross OECD countries
gen ppa = cond(cname=="Australia",1.503, ///
		  cond(cname=="France",0.853, ///
		  cond(cname=="Israel",3.973, ///
		  cond(cname=="Mexico",7.668, ///
		  cond(cname=="Peru",., ///
		  cond(cname=="Poland",1.801, ///
		  cond(cname=="Serbia",., ///
		  cond(cname=="Slovenia",0.637, ///
		  cond(cname=="South Africa",4.569, ///
		  cond(cname=="Taiwan",., .))))))))))
		  		  
gen hceduc_ppa = hceduc/ppa
twoway (scatter hceduc_ppa  quantile, msize(vsmall)) if year==2010 & !mi(hceduc_ppa), by(cname)

// see how hcmed is built in France
twoway (scatter hmcmed quantile, msize(small)) (scatter hncmed quantile, msize(small)) ///
	if cname=="France", by(year, yrescale)

twoway (scatter hmc quantile, msize(small) yscale(range(0) axis(1))) ///
	(scatter hmcmed quantile, msize(small) yaxis(2) yscale(range(0) axis(2))) if ccyy=="fr10"


// see how rent data works
gen diff_hmchousa_hchousa = 2*(hmchousa-hchousa)/(hmchousa+hchousa)
sum diff_hmchousa_hchousa // on remarque que ces deux var sont peu ou prou les memes

gen diff_hnchousi_hchousi = 2*(hnchousi-hchousi)/(hnchousi+hchousi)
sum diff_hnchousi_hchousi // on peut également considérer hnchousi = hchousi

twoway (scatter hchousa quantile if quantile>4, msize(vsmall)) if year==2010, by(cname, yrescale)
twoway (scatter hchousi quantile if quantile>4, msize(vsmall)) if year==2010, by(cname, yrescale)

gen hchous_total = cond(mi(hchousa),hchousi, ///
				   cond(mi(hchousi),hchousa, ///
				   hchousa+hchousi))
				   
twoway (scatter hchous_total quantile, msize(vsmall)) if year==2010, by(cname, yrescale)
gen rent_over_income = hchous_total/threshold
twoway (scatter rent_over_income quantile if quantile>4, msize(vsmall)) if year==2010, by(cname, yrescale)

// remove rent from consumption
gen hmc_wo_rent = hmc - hchousa
twoway (scatter hmc_wo_rent  quantile, msize(vsmall)) if year==2010, by(cname, yrescale)
twoway (scatter hmc_wo_rent  threshold, msize(vsmall)) if year==2010, by(cname, yrescale xrescale)

gen prop_wo_rent = hmc_wo_rent/threshold
twoway (scatter prop_wo_rent  threshold if quantile>4, msize(vsmall)) ///
	if year==2010, by(cname, yrescale xrescale)
	
// we can verify that previous hypothesis on health consumption is still valid
twoway (scatter hmc_wo_rent quantile, msize(small) yscale(range(0) axis(1))) ///
	(scatter hmcmed quantile, msize(small) yaxis(2) yscale(range(0) axis(2))) if ccyy=="fr10"
