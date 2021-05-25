
# Eurovision Web Scraping

library(dplyr)


df <- read.csv("https://query.data.world/s/mokmfaxjasujynpim4kx3nv2jy7azo", header=TRUE, stringsAsFactors=FALSE, sep = ";")

# year, Country_of_jury, member_id, gender, a data_of_birth rozbijac na rok, miesiac, dzien i tworzyc kolumne (wiek) ?

df <- df %>% select(event.year, Country.of.jury, Member.id, Gender, Date.of.birth)
colnames(df) <- c("year", "country_of_jury", "member_id", "gender", "birthdate")

for(i in 1:nrow(df)){
  aux <- strsplit(df$birthdate[i], "-")[[1]]
  df$birthyear[i] <- aux[1]
  df$birthmonth[i] <- aux[2]
  df$birthday[i] <- aux[3]
  
}
df$birthday <- as.integer(df$birthday)
df$birthmonth <- as.integer(df$birthmonth)
df$birthyear <- as.integer(df$birthyear)


male_count <- df %>% filter(gender == "male") %>% group_by(year, country_of_jury) %>% summarise(male_count = n())
df <- df %>% mutate(age = year - birthyear)
mean_age <- df %>% group_by(year, country_of_jury) %>% summarise(mean_age = mean(age))

res <- male_count
res$mean_age <- mean_age$mean_age

write.csv2(res, "jury.csv", row.names = F)






