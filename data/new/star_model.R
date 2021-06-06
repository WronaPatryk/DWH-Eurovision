

library(dplyr)

pg <- read.csv2("points_given.csv")

gdp <- read.csv2("gdp.csv")
colnames(gdp) <- c("Voting", colnames(gdp)[2:length(colnames(gdp))])

aux <- pg %>% left_join(gdp, by = c("Voting","Year") )

gd <- read.csv2("geographic_dimension.csv")
colnames(gd) <- c("Voting", colnames(gd)[2:length(colnames(gd))])


aux2 <- aux %>% left_join(gd, by = c("Voting") )

jury <- read.csv2("jury.csv")
colnames(jury) <- c("Year","Voting", colnames(jury)[3:length(colnames(jury))])

aux3 <- aux2 %>% left_join(jury, by =c("Voting", "Year"))

td <- read.csv2("time_dimension.csv")
aux4 <- aux3 %>% left_join(td, by = "Year")

cs <- read.csv2("contestants.csv")
colnames(cs) <- c("Year", "Voting", colnames(cs)[3:length(colnames(cs))])

res <- aux4 %>% left_join(cs, by = c("Year", "Voting"))



write.csv2(res, "star_model.csv")

