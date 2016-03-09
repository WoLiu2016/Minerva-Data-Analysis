**import using dataset  815 obs
import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\asenegal_mini_minorchange.xlsx", sheet("Sheet 1") firstrow
gen id2 = _n
save "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\matchuse.dta"

clear

import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\gsenegal_exp.xlsx", sheet("Sheet 1") firstrow
gen id1 = _n
rename dyad_name DYAD_NAME
rename adm_1 ADMIN1
rename year YEAR
rename event_date EVENT_DATE
**use reclink to do fuzzy match, USE DYAD_NAME, ADMIN1, ADMIN2 and EVENT_DATE (NO EXACT MATCH REQUIRED)
cd "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal"
reclink EVENT_DATE DYAD_NAME ADMIN1 YEAR using matchuse.dta, gen(myscore) idm(id1) idu(id2) required(YEAR) orblock(none)
gsort -_merge id1
**Unique Master (UCDP EXPAND) Cases: matched = 313 (1351 entries), unmatched = 137
**Unique UCDP records: matched = 149/186
**Unique ACLED records: matched = 175/815

**THREE DAY FRAME: narrow the matched cases to three day difference
gen DIF =  EVENT_DATE - UEVENT_DATE
gen threeday_merge = _merge
replace threeday_merge = 1 if abs(DIF)>3
table threeday_merge
gsort -threeday_merge id1
**Unique UCDP Expanded matched 134/450 (151 entries)
**Unique UCDP matched 66/186
