# Minerva-Data-Analysis
## Five R Scripts
For Nigeria, Senegal, Uganda, Somalia, DRC five countries:
1.Expand UCDP datasets to atomic event version which ACLED is.
2.Try to fill expanded UCDP with relevent ACLED entries (SAME DATE, ACTORS and LOCATIONs)
3.For the events which have no relevent ACLED entries, divide the fatality with the dates duration of each event

For example, if a event lasts 30 days, and no record for it in ACLED, each entry receives 1/30 of the total fatality
of this event coded in UCDP. If a event lasts 300 dyas, and 100 records for the same event found in ACLED, then each of the
left entries receives 1/200 of total fatality(UCDP) minus total death of the 100 records(ACLED).

## Five data files for Tableau analysis


## Fuzzy lookup between UCDP and ACLED
0. install the fuzzy lookup package in stata using the following code: "ssc install reclink"
1. the expanded dataset is the master dataset, the other dataset is the one used to find fuzzy match
2. make sure two datasets have a unique id (id1 and id2)
3. make sure the matching fields have the same name (dyad_name, event_date etc)
4. change all date types to numeric
5. import the dataset used for fuzzy match, sort by id2 and save as a .dta file
6. import the master dataset, sort by id1 
7. write the following code: "reclink event_date admin2 dyad_name using [file path of the dataset used for match], gen(myscore) idm(id1) idu(id2)"
