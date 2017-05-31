set linesize 200
/* Compute some mean value based on quantiles of income */

/* This program computes quantiles of income and outputs a CSV */
capture program drop csv_percentiles
program csv_percentiles
	syntax varlist, ccyy(string) [ n_quantiles(integer 100) ]
		
	_pctile dhi, nquantiles(`n_quantiles')
	
	forvalues i = 1(1)`n_quantiles' {
		local quant`i' = r(r`i')
	}
	
	capture drop dhi_quantiles
	quiet xtile dhi_quantiles = dhi [w=hwgt], nquantiles(`n_quantiles')
	
	forvalues x = 1(1)`n_quantiles' {
		di `x' ",`ccyy'," cname "," year "," `quant`x'' _continue
		foreach variable of local varlist {
			quiet sum `variable' if dhi_quantiles==`x' [w=hwgt]
			di "," round(r(mean),1) _continue
		}
		di
	}
end


/* This program takes datasets as input
and makes a call to csv_percentiles once for each file */
capture program drop multiple_csv
program multiple_csv
	syntax namelist, variables(namelist) [ n_quantiles(integer 100) ]
	
	di "quantile,ccyy,cname,year,threshold" _continue
	foreach variable of local variables {
		di ",`variable'" _continue
	}
	di

	foreach ccyy of local namelist {
		quiet use $`ccyy'h, clear
		csv_percentiles `variables', ccyy(`ccyy') n_quantiles(`n_quantiles')
	}
end


/* Calls function on desired datasets */
multiple_csv au10 do07 fr05 fr10 il05 il07 il10 mx08 mx10 ///
pe07 pe10 pl07 pl10 rs06 rs10 si07 si10 za08 za10 tw07 tw10 , ///
variables(hc hmc hmchousa hnchousi hcmed hmcmed hncmed hceduc hmceduc ///
hnceduc hncbgifte hncbgiftg hncbgifto hchousa hchousi) 
