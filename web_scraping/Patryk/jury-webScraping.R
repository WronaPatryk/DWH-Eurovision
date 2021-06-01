
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
  summarise(male_count = n())
df <- df %>% mutate(age = year - birthyear)
mean_age <- df %>%
  group_by(year, country_of_jury, whichContest) %>%
  summarise(mean_age = mean(age))

res <- sex_count
res$mean_age <- mean_age$mean_age

### take only finals
res <- res[res$whichContest == 'f',]
res <- res %>%
  select(-whichContest)

### mean_age to categories
res$mean_age <- cut(res$mean_age,c(18, 35, 38, 43, 50, 72))
res <- res %>%
  mutate(mean_age_category = case_when(
    mean_age == "(18,35]" ~ "Very young",
    mean_age == "(35,38]" ~ "Young",
    mean_age == "(38,43]" ~ "Middle",
    mean_age == "(43,50]" ~ "Old",
    mean_age == "(50,72]" ~ "Very old",
  )) %>%
  select(-mean_age)

### change column names
colnames(res) <- c("Year", "Country.of.jury", "Male.count", "Mean.age.category")

write.csv2(res, "../../data/new/jury.csv", row.names = F)


