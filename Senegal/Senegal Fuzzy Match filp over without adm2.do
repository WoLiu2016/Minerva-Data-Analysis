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
rename YEAR year
rename EVENT_DATE event_date

**use reclink to do fuzzy match, USE DYAD_NAME, ADMIN1, ADMIN2 and EVENT_DATE (NO EXACT MATCH REQUIRED EXCEPT YEAR)
cd "C:\Users\User\Documents\UMD\summer research\Conflict\Minerva-Data-Analysis\Senegal"
reclink event_date dyad_name adm_1 year using matchuseflip.dta, gen(myscore) idm(id2) idu(id1) required (year) orblock(none)
gsort -_merge id1
**Unique Master (ACLED) Cases: matched = 253 (1481 entries), unmatched = 562
**Uique UCDP Expanded records: matched = 280 (out of 450)
**Unique UCDP records: matched = 143 (out of 186)

**THREE DAY FRAME: narrow the matched cases to three day difference
gen diff =  event_date - Uevent_date
gen threeday_merge = _merge
replace threeday_merge = 1 if abs(diff)>3
table threeday_merge
gsort -threeday_merge id1
**Unique Master Cases: matched = 134 (155 entries), unmatched = 681
**Unique UCDP Expanded records: matched = 107/450
**Unique UCDP records: matched = 78/186

