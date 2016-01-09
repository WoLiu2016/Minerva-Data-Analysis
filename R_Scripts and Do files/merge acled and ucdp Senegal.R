##For Nigeria, Senegal, Uganda, Somalia, DRC five countries:
##1.Expand UCDP datasets to atomic event version which ACLED is.
##2.Try to fill expanded UCDP with relevent ACLED entries (SAME DATE, ACTORS and LOCATIONs)
##3.For the events which have no relevent ACLED entries, divide the fatality with the dates duration of each event
##For example, if a event lasts 30 days, and no record for it in ACLED, each entry receives 1/30 of the total fatality
##of this event coded in UCDP. If a event lasts 300 dyas, and 100 records for the same event found in ACLED, then each of the
##left entries receives 1/200 of total fatality(UCDP) minus total death of the 100 records(ACLED).

##use packages and read ACLED, UCDP-GED datasets.
library(dplyr)
library(openxlsx)
library(data.table)
library(rJava)
library(Hmisc)
library(reshape)

acled <- read.xlsx("./Data/ACLED_v5_dyadic.xlsx")
ged<- read.xlsx("./Data/ged20.xlsx")

##create Senegal sub-datasets
asenegal<- acled[acled$COUNTRY=="Senegal",]
gsenegal<- ged[ged$country=="Senegal",]

##Create mini Senegal datasets
##ACLED Senegal mini dataset (815 obs. of 15 vars)
asenegal_mini<- asenegal[,c(1,2,4,5,7,8,10,11,13,14,15,16,17,19,25)]
##UCDP Senegal mini dataset (305 obs. of 17 vars)
gsenegal_mini<- gsenegal[,c(1,2,3,4,5,8,11,14,17,25,26,27,28,33,37,38,43)]

##Change the date type of ACLED and UCDP Senegal mini datasets and SORT
asenegal_mini$EVENT_DATE<- as.Date(asenegal_mini$EVENT_DATE, origin = "1900-01-01")
asenegal_mini$DYAD_NAME<- paste(as.character(asenegal_mini$ACTOR1),as.character(asenegal_mini$ACTOR2), sep = "-")
asenegal_mini<- arrange(asenegal_mini, EVENT_DATE)

gsenegal_mini$date_start <- as.Date(gsenegal_mini$date_start)
gsenegal_mini$date_end <- as.Date(gsenegal_mini$date_end)

##Cut the UCDP Senegal mini from 1997 to 2014 and SORT
##UCDP Senegal mini dataset (1997-2014) (186 obs. of 17 vars)
gsenegal_mini<- gsenegal_mini[which(as.numeric(gsenegal_mini$year)>1996),]
gsenegal_mini<- arrange(gsenegal_mini, date_start)

##Create day difference variable in UCDP Senegal mini
gsenegal_mini$date_diff <- gsenegal_mini$date_end - gsenegal_mini$date_start
gsenegal_mini$date_diff <- as.numeric(gsenegal_mini$date_diff)
table(gsenegal_mini$date_diff)
##   0   1   2   3   4   5   6   7   8   9  12  14  16  29  64 
## 155  10   2   1   1   1   3   1   2   2   1   3   2   1   1

## Senegal outputs for Tableau analysis
## write.xlsx(gsenegal_mini, "./gsenegal_mini.xlsx")
## write.xlsx(asenegal_mini,"./asenegal_mini.xlsx")

##Expand the UCDP Nigeria mini according to day difference
gsenegal_exp<- untable(gsenegal_mini, num = gsenegal_mini[,18]+1)
gsenegal_exp$dupnum <- as.character(rownames(gsenegal_exp))

for (i in 1:nrow(gsenegal_exp)) {
        if (grepl("\\.", gsenegal_exp[i,19]) == FALSE) {
                gsenegal_exp[i,19]<- paste(gsenegal_exp[i,19],"0",sep = ".")
        }
}
gsenegal_exp$dupnum <- sub(".*\\.", "", gsenegal_exp$dupnum)
gsenegal_exp$dupnum<- as.difftime(as.integer(gsenegal_exp$dupnum), units = "days")
gsenegal_exp$event_date <- gsenegal_exp$date_start + gsenegal_exp$dupnum
gsenegal_exp$event_length <- gsenegal_exp$date_diff+1
gsenegal_exp<- gsenegal_exp[,c(1:17,21,19,20)]
gsenegal_exp<- arrange(gsenegal_exp, event_date)

if (!file.exists("./Senegal/gsenegal_exp.xlsx")){
        write.xlsx(gsenegal_exp, "./gsenegal_exp.xlsx")
}

##Create ACLED dyad and UCDP dyad datasets to merge
gsenegal_dyad<- gsenegal_exp[,c(20,8,9,12,13,11,17,18)]
asenegal_dyad<- asenegal_mini[,c(3,6,8,12,13,14,15,16)]

