## 1. Libraries & data load
library(dplyr)
library(stringr)
df <- read.csv("../data/original/contestants.csv")

## 2. Remove redundant
df <- df %>%
  select(-c(to_country_id, place_contest, sf_num, running_final, running_sf, place_final,
         points_final, place_sf, points_sf, points_tele_final, points_jury_final,
         points_tele_sf, points_jury_sf, youtube_url))

## 3. Lyrics to its length
df$lyrics = str_length(df$lyrics)

## 4. Length to categories
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

write.csv2(df, "../data/new/contestants.csv", row.names = F)