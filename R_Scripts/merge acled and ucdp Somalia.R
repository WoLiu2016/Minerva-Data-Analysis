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

##create Somalia sub-datasets
asomalia<- acled[acled$COUNTRY=="Somalia",]
gsomalia<- ged[ged$country=="Somalia",]

##Create mini Somalia datasets
##ACLED Somalia mini dataset (15150 obs. of 15 vars)
asomalia_mini<- asomalia[,c(1,2,4,5,7,8,10,11,13,14,15,16,17,19,25)]
##UCDP Somalia mini dataset (3402 obs. of 17 vars)
gsomalia_mini<- gsomalia[,c(1,2,3,4,5,8,11,14,17,25,26,27,28,33,37,38,43)]

##Change the date type of ACLED and UCDP Somalia mini datasets and SORT
asomalia_mini$EVENT_DATE<- as.Date(asomalia_mini$EVENT_DATE, origin = "1900-01-01")
asomalia_mini<- arrange(asomalia_mini, EVENT_DATE)

gsomalia_mini$date_start <- as.Date(gsomalia_mini$date_start)
gsomalia_mini$date_end <- as.Date(gsomalia_mini$date_end)

##Cut the UCDP Somalia mini from 1997 to 2014 and SORT
##UCDP Somalia mini dataset (1997-2014) (3063 obs. of 17 vars)
gsomalia_mini<- gsomalia_mini[which(as.numeric(gsomalia_mini$year)>1996),]
gsomalia_mini<- arrange(gsomalia_mini, date_start)

##Create day difference variable in UCDP Somalia mini
gsomalia_mini$date_diff <- gsomalia_mini$date_end - gsomalia_mini$date_start
gsomalia_mini$date_diff <- as.numeric(gsomalia_mini$date_diff)
table(gsomalia_mini$date_diff)
##    0    1    2    3    4    5    6    7   10   11   14   19   20   23   24   25   29   30   31   45   46   70   71  118  206 
## 2524  124  285   60   13   10   14    7    1    3    2    1    2    1    1    1    2    4    2    1    1    1    1    1    1 

## Somalia outputs for Tableau analysis
## write.xlsx(gsomalia_mini, "./gsomalia_mini.xlsx")
## write.xlsx(asomalia_mini,"./asomalia_mini.xlsx")

## Subset the events which last 1 day in UCDP Somalia mini
## gsomalia_d1<- gsomalia_mini[which(gsomalia_mini$date_diff==0),]
## gsomalia_d1<- arrange(gsomalia_d1, date_start)

## Subset the events which last 2 days in UCDP Somalia mini
## gsomalia_d2<- gsomalia_mini[which(gsomalia_mini$date_diff==1),]
## gsomalia_d2<- arrange(gsomalia_d2, date_start)

##Expand the UCDP Somalia mini according to day difference
gsomalia_exp<- untable(gsomalia_mini, num = gsomalia_mini[,18]+1)
gsomalia_exp$dupnum <- as.character(rownames(gsomalia_exp))

for (i in 1:nrow(gsomalia_exp)) {
        if (grepl("\\.", gsomalia_exp[i,19]) == FALSE) {
                gsomalia_exp[i,19]<- paste(gsomalia_exp[i,19],"0",sep = ".")
        }
}

gsomalia_exp$dupnum <- sub(".*\\.", "", gsomalia_exp$dupnum)
gsomalia_exp$dupnum<- as.difftime(as.integer(gsomalia_exp$dupnum), units = "days")
gsomalia_exp$event_date <- gsomalia_exp$date_start + gsomalia_exp$dupnum
gsomalia_exp$event_length <- gsomalia_exp$date_diff+1
gsomalia_exp<- gsomalia_exp[,c(1:17,21,19,20)]
gsomalia_exp<- arrange(gsomalia_exp, event_date)

if (!file.exists("./Somalia/gsomalia_exp.xlsx")){
        write.xlsx(gsomalia_exp, "./gsomalia_exp.xlsx")
}

##Create ACLED dyad and UCDP dyad datasets to merge
gsomalia_dyad<- gsomalia_exp[,c(20,8,9,12,13,11,17,18)]
asomalia_dyad<- asomalia_mini[,c(3,6,8,12,13,14,15)]