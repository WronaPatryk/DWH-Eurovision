## 1. Libraries & data load
library(dplyr)
library(stringr)
df <- read.csv("../data/original/contestants.csv")

## 2. Remove redundant
df <- df %>%
  select(-c(to_country_id, place_contest, sf_num, running_final, running_sf, place_final,
         points_final, place_sf, points_sf, points_tele_final, points_jury_final,
         points_tele_sf, points_jury_sf, youtube_url))

## 3. Correct country names
df$to_country[df$to_country == "Netherlands"] <- "The Netherlands"
df$to_country[df$to_country == "North Macedonia"] <- "Macedonia"
df$to_country[df$to_country == "Bosnia & Herzegovina"] <- "Bosnia and Herzegovina"
df$to_country[df$to_country == "Serbia & Montenegro"] <- "Serbia and Montenegro"

## 4. Lyrics to its length
df$lyrics = str_length(df$lyrics)

## 5. Length to categories
df$lyrics <- cut(df$lyrics, c(0, 750, 1000, 1250, 1500, 10000))
df <- df %>%
  mutate(lyrics_length_category = case_when(
    lyrics == "(0,750]" ~ "Very short",
    lyrics == "(750,1e+03]" ~ "Short",
    lyrics == "(1e+03,1.25e+03]" ~ "Middle",
    lyrics == "(1.25e+03,1.5e+03]" ~ "Long",
    lyrics == "(1.5e+03,1e+04]" ~ "Very long",
  )) %>%
  select(-lyrics)

colnames(df) <- c("Year", "Country", "Performer", "Song", "Composers", "Lyricists", "Lyrics.length.category")

## 6. Remove black values
df[df == ""] <- "Unknown"

## 7. Only >=1975 years
df <- df %>%
  filter(Year >= 1975)

## 8. Remove 2020
df <- df %>%
  filter(Year < 2020)

df <- rbind(df, c(2021, "Lithuania", "The Roop", "Discoteque", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Slovenia", "Ana Sokliè", "Amen", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Russia", "Manizha", "Russian Woman", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Sweden", "Tusse", "Voices", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Australia", "Montaigne", "Technicolour", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Macedonia", "Vasil", "Here I Stand", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Ireland", "Lesley Roy", "Maps", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Cyprus", "Elena Tsagrinou", "El Diablo", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Norway", "TIX", "Fallen Angel", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Croatia", "Albina", "Tick-Tock", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Belgium", "Hooverphonic", "The Wrong Place", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Israel", "Eden Alene", "Set Me Free", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Romania", "Roxen", "Amnesia", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Azerbaijan", "Efendi", "Mata Hari", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Ukraine", "Go_A", "Shum", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Malta", "Destiny", "Je me casse", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "San Marino", "Senhit", "Adrenalina", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Estonia", "Uku Suviste", "The Lucky One", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Czech Republic", "Benny Cristo", "omaga", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Greece", "Stefania", "Last Dance", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Austria", "Vincent Bueno", "Amen", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Poland", "Rafa³", "The Ride", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Moldova", "Natalia Gordienko", "Sugar", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Iceland", "Da??i og Gagnamagni??", "10 Years", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Serbia", "Hurricane", "Loco Loco", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Georgia", "Tornike Kipiani", "You", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Albania", "Anxhela Peristeri", "Karma", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Portugal", "The Black Mamba", "Love Is on My Side", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Bulgaria", "Victoria", "Growing Up Is Getting Old", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Finland", "Blind Channel", "Dark Side", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Latvia", "Samanta Tina", "The Moon Is Rising", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Switzerland", "Gjon's Tears", "Tout l'univers", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Denmark", "Fyr & Flamme", "Ove os pa hinanden", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "United Kingdom", "James Newman", "Embers", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Spain", "Blas Cantó", "Voy a quedarme", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Germany", "Jendrik", "I Don't Feel Hate", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "France", "Barbara Pravi", "Voila", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "The Netherlands", "Jeangu Macrooy", "Birth of a New Age", "Unknown", "Unknown", "Unknown"))
df <- rbind(df, c(2021, "Italy", "Maneskin", "Zitti e buoni", "Unknown", "Unknown", "Unknown"))

## 8. Semicolons to commas
df <- sapply(df, gsub, pattern = ";", replacement= ",")

## 9. Add Serbia and Montenegro 2006
df <- rbind(df, c(2006, "Serbia and Montenegro", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown"))

write.csv2(df, "../data/new/contestants.csv", row.names = F)
