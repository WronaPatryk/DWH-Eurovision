# Main file scrapping
start_time <- Sys.time()

## 1. Libraries & data load
library(dplyr)
library(httr)
library(readxl)
GET("https://query.data.world/s/snzencp3moo66p4vwuudphzv76syts", write_disk(tf <- tempfile(fileext = ".xlsx")))
df <- data.frame(read_excel(tf))

## 2. Remove unused column
df <- within(df, rm("Edition", "Duplicate"))

## 3. Correct country names
df[df=="Bosnia & Herzegovina"] <- "Bosnia and Herzegovina"
df[df=="F.Y.R. Macedonia"] <- "Macedonia"
df[df=="North Macedonia"] <- "Macedonia"
df[df=="Serbia & Montenegro"] <- "Serbia and Montenegro"
df[df=="The Netherands"] <- "The Netherlands"

## 4. Create list with information about countries' participation years
all_countries <- unique(c(unique(df$From.country), unique(df$To.country)))

years_when_country_in_esc <- vector("list", length = 54)
names(years_when_country_in_esc) <- all_countries
for (country in all_countries) {
  years_when_country_in_esc[country] <- ""
}

interval1 <- Sys.time()

for(to in all_countries){
  for(i in 1:nrow(df))
    if(df[i,]$From.country == to)
      if(!grepl(df[i,]$Year, years_when_country_in_esc[to], fixed = TRUE))
        years_when_country_in_esc[to] <- paste0(years_when_country_in_esc[to], df[i,]$Year, ',')
  years_when_country_in_esc[to] <- substr(years_when_country_in_esc[to],1,nchar(years_when_country_in_esc[to])-1)
}

## 5. Take only finals
df <- df[df$X.semi...final == 'f',]
df <- within(df, rm("X.semi...final"))

## 6. Remove unnecessary rows
df <- df[df$From.country != df$To.country,]

## 7. New measures: all points gotten by year [from juries + from televoters + full]
jury_points <- df %>%
  filter(Jury.or.Televoting == "J") %>%
  group_by(Jury.or.Televoting, Year, To.country) %>%
  summarise(Jury.points.this.year = sum(Points))

tele_points <- df %>%
  filter(Jury.or.Televoting == 'T') %>%
  group_by(Jury.or.Televoting, Year, To.country) %>%
  summarise(Tele.points.this.year = sum(Points))

df <- merge(df, jury_points, by = c("Year", "To.country"), all = TRUE)
df <- merge(df, tele_points, by = c("Year", "To.country"), all = TRUE)
df <- within(df, rm("Jury.or.Televoting", "Jury.or.Televoting.y"))
df[is.na(df)] <- 0
df$All.points.this.year <- df$Jury.points.this.year + df$Tele.points.this.year

## 8. Correct badly loaded data - Latvia 2003 instead of Lithuania 2003
df[df$Year == 2003 & df$To.country == "Lithuania",]$To.country <- "Latvia"

interval2 <- Sys.time()

## 9. New measures
### a) all points from voting to voted
### b) all points from voting to all the countries, where voted one is in the final
### c) all points to voted, when voting one takes part
### d) mean countries taking part, when voting in the game and voted is in the final

### a)
all_points_from_voting_to_voted <- df %>%
  group_by(From.country, To.country) %>%
  summarise(All.points.from.voting.to.voted = sum(Points))
df <- merge(df, all_points_from_voting_to_voted, by = c("From.country", "To.country"))

### b)
years_when_country_in_finals <- vector("list", length = 54)
names(years_when_country_in_finals) <- all_countries
for (country in all_countries) {
  years_when_country_in_finals[country] <- ""
}

interval3 <- Sys.time()

for(to in all_countries){
  for(i in 1:nrow(df))
    if(df[i,]$To.country == to)
      if(!grepl(df[i,]$Year, years_when_country_in_finals[to], fixed = TRUE))
        years_when_country_in_finals[to] <- paste0(years_when_country_in_finals[to], df[i,]$Year, ',')
  years_when_country_in_finals[to] <- substr(years_when_country_in_finals[to],1,nchar(years_when_country_in_finals[to])-1)
}

interval4 <- Sys.time()

df$All.points.from.voting.when.voted.in.final <- 0
#counter <- 0 # uncomment for testing [long time]
for (from in all_countries){
  for (to in all_countries){
    if(from == to)
      next
    counter <- counter + 1
    all_points_from_voting_when_voted_in_final <- 0
    for(i in 1:nrow(df))
      if(from == df[i,]$From.country)
        if(grepl(df[i,]$Year, years_when_country_in_finals[to], fixed = TRUE))
          all_points_from_voting_when_voted_in_final <- all_points_from_voting_when_voted_in_final + df[i,]$Points
         
    for(i in 1:nrow(df))
      if(from == df[i,]$From.country)
        if(to == df[i,]$To.country)
          df$All.points.from.voting.when.voted.in.final[i] <- all_points_from_voting_when_voted_in_final
    #if(counter == 21) # uncomment for testing [long time]
    #  break # uncomment for testing [long time]
  }
  #if(counter == 21) # uncomment for testing [long time]
  #  break # uncomment for testing [long time]
}

interval5 <- Sys.time()

### c) & d)
df$All.points.to.voted.when.voting.takes.part <- 0
df$Mean.countries.taking.part <- 0
#counter <- 0 # uncomment for testing [long time]
for (from in all_countries){
  for (to in all_countries){
    if(from == to)
      next
    # counter <- counter + 1 # uncomment for testing [long time]
    all_points_to_voted_when_voting_takes_part <- 0
    mean_countries_taking_part <- 0
    for(i in 1:nrow(df))
      if(to == df[i,]$To.country)
        if(grepl(df[i,]$Year, years_when_country_in_esc[from], fixed = TRUE)){
          all_points_to_voted_when_voting_takes_part <- all_points_to_voted_when_voting_takes_part + df[i,]$Points
          if(df[i,]$Jury.or.Televoting.x == 'J')
            mean_countries_taking_part <- mean_countries_taking_part + 1
        }
    
    years_when_country_in_esc_splitted <- strsplit(years_when_country_in_esc[[from]], ',')
    # print(years_when_country_in_esc_splitted) # uncomment for testing
    years_when_country_in_finals_splitted <- strsplit(years_when_country_in_finals[[to]], ',')
    # print(years_when_country_in_finals_splitted) # uncomment for testing
    how_many_contests_together <- length(intersect(years_when_country_in_esc_splitted[[1]], years_when_country_in_finals_splitted[[1]]))
    # print(how_many_contests_together) # uncomment for testing
    
    mean_countries_taking_part <- mean_countries_taking_part + how_many_contests_together
    # print(paste0(from, "...", to, "...", mean_countries_taking_part, "...", how_many_contests_together)) # uncomment for testing
    if(how_many_contests_together > 0)
      mean_countries_taking_part <- mean_countries_taking_part / how_many_contests_together
    else
      mean_countries_taking_part <- -1
    # print(mean_countries_taking_part) # uncomment for testing
    
    for(i in 1:nrow(df))
      if(from == df[i,]$From.country)
        if(to == df[i,]$To.country){
          df$All.points.to.voted.when.voting.takes.part[i] <- all_points_to_voted_when_voting_takes_part
          df$Mean.countries.taking.part[i] <- mean_countries_taking_part
        }
    #if(counter == 21) # uncomment for testing [long time]
    #  break # uncomment for testing [long time]
  }
  #if(counter == 21) # uncomment for testing [long time]
  #  break # uncomment for testing [long time]
}

stop_time <- Sys.time()

#sample_n(df[df$From.country == 'Belgium',], 50) # uncomment for testing
#sample_n(df, 100) # uncomment for testing
#df[df$To.country == "Monaco" & df$Year == 1975,] # uncomment for testing

print(stop_time - start_time)
print(interval1 - start_time)
print(interval2 - interval1)
print(interval3 - interval2)
print(interval4 - interval3)
print(interval5 - interval4)
print(stop_time - interval5)

colnames(df) <- c("Voting", "Voted", "Year", "Jury.or.televoting", "Points.given", "Jury.points.this.year",
                  "Tele.points.this.year", "All.points.this.year", "All.points.from.voting.to.voted",
                  "All.points.from.voting.when.voted.in.final", "All.points.to.voted.when.voting.takes.part",
                  "Mean.countries.taking.part")

write.csv2(df, "../data/new/points_given_without_contests_together.csv", row.names = F)

### 10. New measure - contests together
df2 <- df
# counter <- 0 # uncomment for testing [long time]
df2$Contests.when.voted.in.finals.and.voting.takes.part <- 0
for (from in all_countries){
  for (to in all_countries){
    if(from == to)
      next
    # counter <- counter + 1 # uncomment for testing [long time]
    years_when_country_in_esc_splitted <- strsplit(years_when_country_in_esc[[from]], ',')
    years_when_country_in_finals_splitted <- strsplit(years_when_country_in_finals[[to]], ',')
    how_many_contests_together <- length(intersect(years_when_country_in_esc_splitted[[1]], years_when_country_in_finals_splitted[[1]]))
    
    for(i in 1:nrow(df2))
      if(from == df2[i,]$From.country)
        if(to == df2[i,]$To.country)
          df2$Contests.when.voted.in.finals.and.voting.takes.part[i] <- how_many_contests_together
    #if(counter == 21) # uncomment for testing [long time]
    #  break # uncomment for testing [long time]
  }
  #if(counter == 21) # uncomment for testing [long time]
  #  break # uncomment for testing [long time]
}
# sample_n(df2, 100) # uncomment for testing [long time]
write.csv2(df2, "../data/new/points_given.csv", row.names = F)
