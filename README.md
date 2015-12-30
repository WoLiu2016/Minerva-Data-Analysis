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
