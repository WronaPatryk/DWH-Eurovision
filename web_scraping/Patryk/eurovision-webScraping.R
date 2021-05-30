
# Eurovision Web Scraping

library(dplyr)


df <- read.csv("https://query.data.world/s/mokmfaxjasujynpim4kx3nv2jy7azo", header=TRUE, stringsAsFactors=FALSE, sep = ";")

# year, Country_of_jury, member_id, gender, a data_of_birth rozbijac na rok, miesiac, dzien i tworzyc kolumne (wiek) ?

df <- df %>% select(event.year, Country.of.jury, Member.id, Gender, Date.of.birth)
colnames(df) <- c("year", "country_of_jury", "member_id", "gender", "birthdate")

#unique(df$country_of_jury)
df$country_of_jury[df$country_of_jury == "Czech-Republic"] <- "Czech Republic"
df$country_of_jury[df$country_of_jury == "Fyr-macedonia"] <- "Macedonia"
df$country_of_jury[df$country_of_jury == "United-kingdom"] <- "United Kingdom"
df$country_of_jury[df$country_of_jury == "San-marino"] <- "San Marino"
df$country_of_jury[df$country_of_jury == "Bosnia-herzegovina"] <- "Bosnia and Herzegovina"

df$whichContest = 'tbc'
whichContestsModulo = 1
whichC = {}
whichC[1] = 'sf1'
whichC[2] = 'sf2'
whichC[3] = 'f'

for(i in 1:nrow(df)){
  aux <- strsplit(df$birthdate[i], "-")[[1]]
  df$birthyear[i] <- aux[1]
  df$birthmonth[i] <- aux[2]
  df$birthday[i] <- aux[3]
  
  if(i == 1) df$whichContest[i] = 'f'
  else if(substring(df$country_of_jury[i-1], 1, 1) > substring(df$country_of_jury[i], 1, 1)){
    whichContestsModulo = whichContestsModulo + 1
    if (whichContestsModulo == 4)
      whichContestsModulo = whichContestsModulo - 3
  }
  df$whichContest[i] = whichC[whichContestsModulo]
}
df$birthday <- as.integer(df$birthday)
df$birthmonth <- as.integer(df$birthmonth)
df$birthyear <- as.integer(df$birthyear)

#df
sex_count <- df %>%
  filter(gender == "male") %>%
  group_by(year, country_of_jury, whichContest) %>%
  summarise(male_count = n()) %>%
  mutate(female_count = 5 - male_count)
df <- df %>% mutate(age = year - birthyear)
mean_age <- df %>%
  group_by(year, country_of_jury, whichContest) %>%
  summarise(mean_age = mean(age))

res <- sex_count
res$mean_age <- mean_age$mean_age
res[res$year == 2017,]

write.csv2(res, "jury.csv", row.names = F)






