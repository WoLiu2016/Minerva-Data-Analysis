ssc install reclink

import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Uganda\guganda_exp_finalmatch.xlsx", sheet("Sheet4") firstrow
sort  id2
save "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Uganda\matchuse.dta"

clear all

import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Uganda\guganda_exp_match1.xlsx", sheet("Sheet1") firstrow clear
sort id1
reclink event_date latitude longitude dyad_name using "./matchuse.dta", gen(myscore) idm(id1) idu(id2)
export excel using "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Uganda\uganda_statamatch.xlsx", firstrow(variables)
