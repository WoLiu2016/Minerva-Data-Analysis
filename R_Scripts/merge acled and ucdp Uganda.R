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

##create Uganda sub-datasets
auganda<- acled[acled$COUNTRY=="Uganda",]
guganda<- ged[ged$country=="Uganda",]

##Create mini Uganda datasets
##ACLED Uganda mini dataset (4381 obs. of 15 vars)
auganda_mini<- auganda[,c(1,2,4,5,7,8,10,11,13,14,15,16,17,19,25)]
##UCDP Uganda mini dataset (1666 obs. of 17 vars)
guganda_mini<- guganda[,c(1,2,3,4,5,8,11,14,17,25,26,27,28,33,37,38,43)]

##Change the date type of ACLED and UCDP Uganda mini datasets and SORT
auganda_mini$EVENT_DATE<- as.Date(auganda_mini$EVENT_DATE, origin = "1900-01-01")
auganda_mini<- arrange(auganda_mini, EVENT_DATE)

guganda_mini$date_start <- as.Date(guganda_mini$date_start)
guganda_mini$date_end <- as.Date(guganda_mini$date_end)

##Cut the UCDP Uganda mini from 1997 to 2014 and SORT
##UCDP Uganda mini dataset (1997-2014) (1425 obs. of 17 vars)
guganda_mini<- guganda_mini[which(as.numeric(guganda_mini$year)>1996),]
guganda_mini<- arrange(guganda_mini, date_start)

##Create day difference variable in UCDP Uganda mini
guganda_mini$date_diff <- guganda_mini$date_end - guganda_mini$date_start
guganda_mini$date_diff <- as.numeric(guganda_mini$date_diff)
table(guganda_mini$date_diff)
##    0    1    2    3    4    5    6    7    8    9   10   11   13   14   15   16   18   20   26   27   29   30   31   37   49   56    
## 1114   67   29   24    7   12   72   12    1    3    1    2    4    3    7    3    2    2    1    3    9   27    1    1    4    1   
##   57   63   90   91  121  140  150  192  364 
##    1    1    1    1    4    1    1    2    1 

## Uganda outputs for Tableau analysis
## write.xlsx(guganda_mini, "./guganda_mini.xlsx")
## write.xlsx(auganda_mini,"./auganda_mini.xlsx")

##Expand the UCDP Nigeria mini according to day difference
guganda_exp<- untable(guganda_mini, num = guganda_mini[,18]+1)
guganda_exp$dupnum <- as.character(rownames(guganda_exp))

for (i in 1:nrow(guganda_exp)) {
        if (grepl("\\.", guganda_exp[i,19]) == FALSE) {
                guganda_exp[i,19]<- paste(guganda_exp[i,19],"0",sep = ".")
        }
}
guganda_exp$dupnum <- sub(".*\\.", "", guganda_exp$dupnum)
guganda_exp$dupnum<- as.difftime(as.integer(guganda_exp$dupnum), units = "days")
guganda_exp$event_date <- guganda_exp$date_start + guganda_exp$dupnum
guganda_exp$event_length <- guganda_exp$date_diff+1
guganda_exp<- guganda_exp[,c(1:17,21,19,20)]
guganda_exp<- arrange(guganda_exp, event_date)

if (!file.exists("./Uganda/guganda_exp.xlsx")){
        write.xlsx(guganda_exp, "./guganda_exp.xlsx")
}

##Create ACLED dyad and UCDP dyad datasets to merge
guganda_dyad<- guganda_exp[,c(20,8,9,12,13,11,17,18)]
auganda_dyad<- auganda_mini[,c(3,6,8,12,13,14,15)]