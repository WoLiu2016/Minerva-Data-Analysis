##use packages and read ACLED, UCDP-GED datasets.
library(dplyr)
library(openxlsx)
library(data.table)
library(rJava)
library(Hmisc)
library(reshape)

acled <- read.xlsx("./Data/ACLED_v5_dyadic.xlsx")
ged<- read.xlsx("./Data/ged20.xlsx")

##create Nigeria sub-datasets
anigeria<- acled[acled$COUNTRY=="Nigeria",]
gnigeria<- ged[ged$country=="Nigeria",]

##Create mini Nigeria datasets
##ACLED Nigeria mini dataset (6781 obs. of 15 vars)
anigeria_mini<- anigeria[,c(1,2,4,5,7,8,10,11,13,14,15,16,17,19,25)]
##UCDP Nigeria mini dataset (2079 obs. of 17 vars)
gnigeria_mini<- gnigeria[,c(1,2,3,4,5,8,11,14,17,25,26,27,28,33,37,38,43)]

##Change the date type of ACLED and UCDP Nigeria mini datasets and SORT
anigeria_mini$EVENT_DATE<- as.Date(anigeria_mini$EVENT_DATE, origin = "1900-01-01")
anigeria_mini<- arrange(anigeria_mini, EVENT_DATE)

gnigeria_mini$date_start <- as.Date(gnigeria_mini$date_start)
gnigeria_mini$date_end <- as.Date(gnigeria_mini$date_end)

##Cut the UCDP Nigeria mini from 1997 to 2014 and SORT
##UCDP Nigeria mini dataset (1997-2014) (2031 obs. of 17 vars)
gnigeria_mini<- gnigeria_mini[which(as.numeric(gnigeria_mini$year)>1996),]
gnigeria_mini<- arrange(gnigeria_mini, date_start)

##Create day difference variable in UCDP Nigeria mini
gnigeria_mini$date_diff <- gnigeria_mini$date_end - gnigeria_mini$date_start
gnigeria_mini$date_diff <- as.numeric(gnigeria_mini$date_diff)
table(gnigeria_mini$date_diff)
##     0    1    2    3    4    5    6    7    8    9   10   11   12   13   14   16   17   18   19   21   22   24   25   27 
##  1630  147   74   33   25    8   20    6    1    3    5    1    2    4    4    2    1    1    1    3    5    2    4    4 
##    29   30   39   43   44   60   61   62   70   87   91  122  151  182  183  213  364 
##     6   14    1    1    1    2    4    1    1    1    2    1    3    1    1    2    3 

##Subset the events which last 1 day in UCDP Nigeria mini
gnigeria_d1<- gnigeria_mini[which(gnigeria_mini$date_diff==0),]
gnigeria_d1<- arrange(gnigeria_d1, date_start)

##Subset the events which last 2 days in UCDP Nigeria mini
gnigeria_d2<- gnigeria_mini[which(gnigeria_mini$date_diff==1),]
gnigeria_d2<- arrange(gnigeria_d2, date_start)

##Expand the UCDP Nigeria mini according to day difference
gexpand<- untable(gnigeria_mini, num = gnigeria_mini[,18]+1)
gexpand$dupnum <- as.character(rownames(gexpand))

for (i in 1:nrow(gexpand)) {
        if (grepl("\\.", gexpand[i,19]) == FALSE) {
                gexpand[i,19]<- paste(gexpand[i,19],"0",sep = ".")
        }
}

gexpand$dupnum <- sub(".*\\.", "", gexpand$dupnum)

gexpand$dupnum<- as.difftime(as.integer(gexpand$dupnum), units = "days")

gexpand$date_duration <- gexpand$date_start + gexpand$dupnum


