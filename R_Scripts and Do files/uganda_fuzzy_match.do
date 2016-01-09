ssc install reclink

import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Uganda\guganda_exp_match1.xlsx", sheet("Sheet2") firstrow
sort  id2
save "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Uganda\matchuse.dta"

import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Uganda\guganda_exp_match1.xlsx", sheet("Sheet1") firstrow clear
sort id1
reclink event_date dyad_name m_admin using matchuse.dta, gen(myscore) idm(id1) idu(id2)
export excel using "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Uganda\uganda_statamatch.xlsx", firstrow(variables)
