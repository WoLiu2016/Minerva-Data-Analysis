**ACLED is the master, UCDP is the using dataset
**import using dataset  450 obs
import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\gsenegal_exp.xlsx", sheet("Sheet 1") firstrow
gen id1 = _n
save "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\matchuseflip.dta"

clear

**import master dataset  815 obs
import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\asenegal_mini_minorchange.xlsx", sheet("Sheet 1") firstrow
gen id2 = _n
rename DYAD_NAME dyad_name
rename ADMIN1 adm_1
rename ADMIN2 adm_2
rename YEAR year
rename EVENT_DATE event_date

**use reclink to do fuzzy match, USE DYAD_NAME, ADMIN1, ADMIN2 and EVENT_DATE (NO EXACT MATCH REQUIRED EXCEPT YEAR)
cd "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal"
reclink event_date dyad_name adm_1 adm_2 year using matchuseflip.dta, gen(myscore) idm(id2) idu(id1) required (year) orblock(none)
gsort -_merge id1
**Unique Master Cases: matched = 205 (793 records), unmatched = 610
**Uique UCDP Expanded records: matched = 221 (out of 450)
**Unique UCDP records: matched = 111 (out of 186)

**mark all the records belong only to ACLED as 2
replace _merge = 2 if _merge == 1 
