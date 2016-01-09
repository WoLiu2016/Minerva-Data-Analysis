##For Nigeria, Senegal, Uganda, Somalia, DRC five countries:
##1.Expand UCDP datasets to atomic event version which ACLED is.
##2.Try to fill expanded UCDP with relevent ACLED entries (SAME DATE, ACTORS and LOCATIONs)
##3.For the events which have no relevent ACLED entries, divide the fatality with the event length of each event
##For example, if a event lasts 30 days, and no record for it in ACLED, each entry receives 1/30 of the total fatality (variable "best_est")
##of this event coded in UCDP. If a event lasts 300 dyas, and 100 records for the same event found in ACLED, then each of the
##left entries receives 1/200 of total fatality(UCDP) minus total death of the 100 records(ACLED).

##Load packages and read ACLED, UCDP-GED datasets.
library(dplyr)
library(openxlsx)
library(data.table)
library(rJava)
library(Hmisc)
library(reshape)

acled <- read.xlsx("./Data/ACLED_v5_dyadic.xlsx")
ged<- read.xlsx("./Data/ged20.xlsx")

##create DRC sub-datasets
adrcongo<- acled[acled$COUNTRY=="Democratic Republic of Congo",]
gdrcongo<- ged[ged$country=="DR Congo (Zaire)",]

##Create mini DRC datasets
##ACLED DRC mini dataset (8876 obs. of 15 vars)
adrcongo_mini<- adrcongo[,c(1,2,4,5,7,8,10,11,13,14,15,16,17,19,25)]
##UCDP DRC mini dataset (2611 obs. of 17 vars)
gdrcongo_mini<- gdrcongo[,c(1,2,3,4,5,8,11,14,17,25,26,27,28,33,37,38,43)]

##Change the date type of ACLED and UCDP DRC mini datasets and SORT
adrcongo_mini$EVENT_DATE<- as.Date(adrcongo_mini$EVENT_DATE, origin = "1900-01-01")
adrcongo_mini$DYAD_NAME<- paste(as.character(adrcongo_mini$ACTOR1),as.character(adrcongo_mini$ACTOR2), sep = "-")
adrcongo_mini<- arrange(adrcongo_mini, EVENT_DATE)

gdrcongo_mini$date_start <- as.Date(gdrcongo_mini$date_start)
gdrcongo_mini$date_end <- as.Date(gdrcongo_mini$date_end)

##Cut the UCDP DRC mini from 1997 to 2014 and SORT
##UCDP DRC mini dataset (1997-2014) (2327 obs. of 17 vars)
gdrcongo_mini<- gdrcongo_mini[which(as.numeric(gdrcongo_mini$year)>1996),]
gdrcongo_mini<- arrange(gdrcongo_mini, date_start)

##Create day difference variable in UCDP DRC mini
gdrcongo_mini$date_diff <- gdrcongo_mini$date_end - gdrcongo_mini$date_start
gdrcongo_mini$date_diff <- as.numeric(gdrcongo_mini$date_diff)
table(gdrcongo_mini$date_diff)
## 0    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   25   26    
##1525  184  62   40   17   30   63   20   17   6   10    3    4    9   24   10   17    2    2    3    5    3    5    3    1    3    
##27    28   29   30   31   33   36   38   43   45   47   48   50   53   55   56   58   60   61   62   76   78   86   88   89   90   91    
##16    11   53   86    4    1    3    1    2    1    1    1    1    1    1    1    4   11    1    1    1    1    1    2    2    3    5     
##101   119  121    123  124  133  150  152  169  180  182  183  211  213  215  252  274  291  302  304  334  364  365 
##1     3    2      1    1    3    1    2    1    3    1    2    1    10   1    1    1    1    1    2    1    12    1 

## DRC outputs for Tableau analysis
## write.xlsx(gdrcongo_mini, "./gdrcongo_mini.xlsx")
## write.xlsx(adrcongo_mini,"./adrcongo_mini.xlsx")

## Subset the events which last 1 day in UCDP DRC mini
## gdrcongo_d1<- gdrcongo_mini[which(gdrcongo_mini$date_diff==0),]
## gdrcongo_d1<- arrange(gdrcongo_d1, date_start)

## Subset the events which last 2 days in UCDP DRC mini
## gdrcongo_d2<- gdrcongo_mini[which(gdrcongo_mini$date_diff==1),]
## gdrcongo_d2<- arrange(gdrcongo_d2, date_start)

##Expand the UCDP DRC mini according to day difference
gdrcongo_exp<- untable(gdrcongo_mini, num = gdrcongo_mini[,18]+1)
gdrcongo_exp$dupnum <- as.character(rownames(gdrcongo_exp))

for (i in 1:nrow(gdrcongo_exp)) {
        if (grepl("\\.", gdrcongo_exp[i,19]) == FALSE) {
                gdrcongo_exp[i,19]<- paste(gdrcongo_exp[i,19],"0",sep = ".")
        }
}

gdrcongo_exp$dupnum <- sub(".*\\.", "", gdrcongo_exp$dupnum)
gdrcongo_exp$dupnum<- as.difftime(as.integer(gdrcongo_exp$dupnum), units = "days")
gdrcongo_exp$event_date <- gdrcongo_exp$date_start + gdrcongo_exp$dupnum
gdrcongo_exp$event_length <- gdrcongo_exp$date_diff+1
gdrcongo_exp<- gdrcongo_exp[,c(1:17,21,19,20)]
gdrcongo_exp<- arrange(gdrcongo_exp, event_date)

if (!file.exists("./DRC/gdrcongo_exp.xlsx")){
        write.xlsx(gdrcongo_exp, "./gdrcongo_exp.xlsx")
}

##Create ACLED dyad and UCDP dyad datasets to merge
gdrcongo_dyad<- gdrcongo_exp[,c(20,8,9,12,13,11,17,18)]
adrcongo_dyad<- adrcongo_mini[,c(3,6,8,12,13,14,15,16)]