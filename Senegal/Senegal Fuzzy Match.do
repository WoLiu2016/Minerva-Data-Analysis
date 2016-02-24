ssc install reclink
**import using dataset  815 obs
import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\asenegal_mini_minorchange.xlsx", sheet("Sheet 1") firstrow
gen id2 = _n
save "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\matchuse.dta"

clear

**import master dataset  450 obs
import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\gsenegal_exp.xlsx", sheet("Sheet 1") firstrow
gen id1 = _n
rename dyad_name DYAD_NAME
rename adm_1 ADMIN1
rename adm_2 ADMIN2
rename year YEAR

**use reclink to do fuzzy match, ONLY USE DYAD_NAME, ADMIN1, ADMIN2 and YEAR(required same)
cd "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal"
reclink DYAD_NAME ADMIN1 ADMIN2 YEAR using matchuse.dta, gen(myscore) idm(id1) idu(id2) required(YEAR) orblock(none)
gsort -_merge id1
table _merge
**Initial mathced dataset  620 obs
**matched = 441 (611 entries), unmatched = 9

**ONE DAY FRAME: narrow the matched cases to one day difference
gen dif = event_date - EVENT_DATE
gen oneday_merge = _merge
replace oneday_merge = 1 if abs(dif)>1
table oneday_merge
gsort -oneday_merge id
export excel using "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\senegal_match_oneday.xlsx", firstrow(variables)
**matched = 20 (20 entries), unmatched = 430 (596 entries)    
**10/450 UCDP events matched before manuel review

**TWO DAY FRAME: narrow the matched cases to two day difference
drop oneday_merge
gen twoday_merge = _merge
replace twoday_merge = 1 if abs(dif)>2
table twoday_merge
gsort -twoday_merge id
export excel using "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\senegal_match_twoday.xlsx", firstrow(variables)
**matched = 51 (51 entries), unmatched = 399 (569 entries)
**29/450 UCDP events matched before manuel review

**THREE DAY FRAME: narrow the matched cases to three day difference
drop twoday_merge
gen threeday_merge = _merge
replace threeday_merge = 1 if abs(dif)>3
table threeday_merge
gsort -threeday_merge id
export excel using "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\senegal_match_threeday.xlsx", firstrow(variables)
**matched = 62 (62 entries), unmatched = 388 (543 entries)
**34/450 UCDP events matched before manuel review

clear

**Add event_date to the used-to-merge var list
import excel "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal\gsenegal_exp.xlsx", sheet("Sheet 1") firstrow
gen id1 = _n
rename dyad_name DYAD_NAME
rename adm_1 ADMIN1
rename adm_2 ADMIN2
rename year YEAR
rename event_date EVENT_DATE
**use reclink to do fuzzy match, USE DYAD_NAME, ADMIN1, ADMIN2 and EVENT_DATE (NO EXACT MATCH REQUIRED)
cd "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal"
reclink DYAD_NAME ADMIN1 ADMIN2 EVENT_DATE YEAR using matchuse.dta, gen(myscore) idm(id1) idu(id2) required(YEAR) orblock(none)
gsort -_merge id1
**Unique Master Cases: matched = 253, unmatched = 197

**TWO DAY FRAME: narrow the matched cases to two day difference
gen DIF =  EVENT_DATE - UEVENT_DATE
gen twoday_merge = _merge
replace twoday_merge = 1 if abs(DIF)>2
table twoday_merge
gsort -twoday_merge id
**matched = 92 (97 entries), unmatched = 358


