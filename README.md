# Minerva-Data-Analysis
## Five R Scripts
For Nigeria, Senegal, Uganda, Somalia, DRC five countries:
1.Expand UCDP datasets to atomic event version which ACLED is.
2.Try to fill expanded UCDP with relevent ACLED entries (SAME DATE, ACTORS and LOCATIONs)
3.For the events which have no relevent ACLED entries, divide the fatality with the dates duration of each event

For example, if a event lasts 30 days, and no record for it in ACLED, each entry receives 1/30 of the total fatality
of this event coded in UCDP. If a event lasts 300 dyas, and 100 records for the same event found in ACLED, then each of the
left entries receives 1/200 of total fatality(UCDP) minus total death of the 100 records(ACLED).

## Final outputs
1. rebel group sub-datasets for each five country
2. UCDP expanded datasets merged with ACLED 
3. Tableau stories


## Fuzzy lookup between UCDP and ACLED
0. install the fuzzy lookup package in STATA using the following code: "ssc install reclink"
1. the expanded dataset is the master dataset, the other dataset is the one used to find fuzzy match
2. make sure two datasets have a unique id (id1 and id2)
3. make sure the matching fields have the same name (dyad_name, event_date, location etc)
4. change all date types to numeric
5. import the dataset used for fuzzy match, sort by id2 and save as a .dta file
6. import the master dataset, sort by id1 
7. write the following code: "reclink event_date admin2 dyad_name using [file path of the dataset used for match], gen(myscore) idm(id1) idu(id2)"

### Minor title changes for fuzzy match
1. Rename  "Military Forces of Nigeria/Uganda/Senegal/Somalia/DRC" to "Government of Nigeria/Uganda/Senegal/Somalia/DR Congo"
2. Nigeria: Rename  "Boko Haram" in ACLED_MINI to "Jama'atu Ahlis Sunna Lidda'awati wal-Jihad" as named in UCDP_EXP
3. DRC: Rename "Government of Democratic Republic of Congo" in ACLED_MINI to "Government of DR Congo" as named in UCDP_EXP

## Logic for populating Fatility number:
1. IF _merge=1 and event_length=1, THEN fatility=best_estimate
2. Sort relid to sort the dataset by event
3. browse the whole dataset, if one event has matched info, then: 1.check if it's a correct match (by looking at the dyad_name fields)2. if correct match, and if best_est>fatility (that is/are matched), then populate the missing fatility by (best_est-sum_matchedfatility)/(number of missing values) 3. if correct match and if best_est<sum_matchedfatility, then simply populate all the event by best_est/event_length

## Rebel Group Analysis
1. Subset the events which have rebel groups involved ( INTER1=2 OR INTER2=2) for five countries.
2. Restructure all the rebel groups to variable "newactor1" and the others to variable "newactor2". The result is: under rebel sub datasets for each country, all rebel groups are recorded "newactor1"; the only rebel groups recorded in "newactor2" are those in event type "Rebel vs. Rebel" (INTERACTION=22).
3. Direct to Tableau to make exploratory analysis.
4. Uganda: 2726 of 4381 events have rebel groups involved
5. DRC: 4373 of 8876 events have rebel groups involved
6. Somalia: 4912 of 15150 events have rebel groups involved
7. Senegal: 291 of 450 events have rebel groups involved
8. Nigeria: 191 of 6781 events have rebel groups involved


