## Rebel group analysis for Senegal, Nigeria, Somalia, DRC and Uganda

##Load packages and read ACLED dataset
library(dplyr)
library(openxlsx)
library(data.table)
library(rJava)
library(Hmisc)
library(reshape)

acled <- read.xlsx("./Data/ACLED_v5_dyadic.xlsx")

##create Senegal sub dataset
asenegal<- acled[acled$COUNTRY=="Senegal",]
##Create rebel sub dataset
##INTER1=2 -> ACTOR1 IS REBEL GROUP; INTER2=2 -> ACTOR2 IS REBEL GROUP
##ROW 10: INTER1;  ROW 13: INTER2;  ROW 11: ACTOR2;  ROW 26: newactor1;  ROW 8: ACTOR1; ROW14: INTERACTION;  ROW27: newactor2
senegal_rebel<- asenegal[which(asenegal$INTER1==2 | asenegal$INTER2==2),]
senegal_rebel$newactor1 <- senegal_rebel$ACTOR1
for (i in 1: nrow(senegal_rebel)) {
            if (senegal_rebel[i,10]> senegal_rebel[i,13]) {
                senegal_rebel[i,26]<- senegal_rebel[i,11]
                senegal_rebel[i,11]<- senegal_rebel[i, 8]
            }
}
senegal_rebel$newactor2<- senegal_rebel$ACTOR2
for (i in 1:nrow(senegal_rebel)){
        if (senegal_rebel[i,14]==20 | senegal_rebel[i,14]==12) {
                senegal_rebel[i,27]<- senegal_rebel[i,26]
                senegal_rebel[i,26]<- senegal_rebel[i,11]
        }
}
##Export excel version for Tableau analysis
write.xlsx(senegal_rebel,"./senegal_rebel.xlsx")

##create Nigeria sub dataset
anigeria<- acled[acled$COUNTRY=="Nigeria",]
##Create rebel sub dataset
nigeria_rebel<- anigeria[which(anigeria$INTER1==2 | anigeria$INTER2==2),]
nigeria_rebel$newactor1 <- nigeria_rebel$ACTOR1
for (i in 1: nrow(nigeria_rebel)) {
        if (nigeria_rebel[i,10]> nigeria_rebel[i,13]) {
                nigeria_rebel[i,26]<- nigeria_rebel[i,11]
                nigeria_rebel[i,11]<- nigeria_rebel[i, 8]
        }
}
nigeria_rebel$newactor2<- nigeria_rebel$ACTOR2
for (i in 1:nrow(nigeria_rebel)){
        if (nigeria_rebel[i,14]==20 | nigeria_rebel[i,14]==12) {
                nigeria_rebel[i,27]<- nigeria_rebel[i,26]
                nigeria_rebel[i,26]<- nigeria_rebel[i,11]
        }
}
##Export excel version for Tableau analysis
##write.xlsx(nigeria_rebel,"./nigeria_rebel.xlsx")

##create Uganda sub dataset
auganda<- acled[acled$COUNTRY=="Uganda",]
##Create rebel sub dataset
uganda_rebel<- auganda[which(auganda$INTER1==2 | auganda$INTER2==2),]
uganda_rebel$newactor1 <- uganda_rebel$ACTOR1
for (i in 1: nrow(uganda_rebel)) {
        if (uganda_rebel[i,10]> uganda_rebel[i,13]) {
                uganda_rebel[i,26]<- uganda_rebel[i,11]
                uganda_rebel[i,11]<- uganda_rebel[i, 8]
        }
}
uganda_rebel$newactor2<- uganda_rebel$ACTOR2
for (i in 1:nrow(uganda_rebel)){
        if (uganda_rebel[i,14]==20 | uganda_rebel[i,14]==12) {
                uganda_rebel[i,27]<- uganda_rebel[i,26]
                uganda_rebel[i,26]<- uganda_rebel[i,11]
        }
}
##Export excel version for Tableau analysis
##write.xlsx(uganda_rebel,"./uganda_rebel.xlsx")

##create DRC sub dataset
adrcongo<- acled[acled$COUNTRY=="Democratic Republic of Congo",]
##Create rebel sub dataset
drcongo_rebel<- adrcongo[which(adrcongo$INTER1==2 | adrcongo$INTER2==2),]
drcongo_rebel$newactor1 <- drcongo_rebel$ACTOR1
for (i in 1: nrow(drcongo_rebel)) {
        if (drcongo_rebel[i,10]> drcongo_rebel[i,13]) {
                drcongo_rebel[i,26]<- drcongo_rebel[i,11]
                drcongo_rebel[i,11]<- drcongo_rebel[i, 8]
        }
}
drcongo_rebel$newactor2<- drcongo_rebel$ACTOR2
for (i in 1:nrow(drcongo_rebel)){
        if (drcongo_rebel[i,14]==20 | drcongo_rebel[i,14]==12) {
                drcongo_rebel[i,27]<- drcongo_rebel[i,26]
                drcongo_rebel[i,26]<- drcongo_rebel[i,11]
        }
}
##Export excel version for Tableau analysis
##write.xlsx(drcongo_rebel,"./drcongo_rebel.xlsx")

##create Somalia sub dataset
asomalia<- acled[acled$COUNTRY=="Somalia",]
##Create rebel sub dataset
somalia_rebel<- asomalia[which(asomalia$INTER1==2 | asomalia$INTER2==2),]
somalia_rebel$newactor1 <- somalia_rebel$ACTOR1
for (i in 1: nrow(somalia_rebel)) {
        if (somalia_rebel[i,10]> somalia_rebel[i,13]) {
                somalia_rebel[i,26]<- somalia_rebel[i,11]
                somalia_rebel[i,11]<- somalia_rebel[i, 8]
        }
}
somalia_rebel$newactor2<- somalia_rebel$ACTOR2
for (i in 1:nrow(somalia_rebel)){
        if (somalia_rebel[i,14]==20 | somalia_rebel[i,14]==12) {
                somalia_rebel[i,27]<- somalia_rebel[i,26]
                somalia_rebel[i,26]<- somalia_rebel[i,11]
        }
}
##Export excel version for Tableau analysis
##write.xlsx(somalia_rebel,"./somalia_rebel.xlsx")
