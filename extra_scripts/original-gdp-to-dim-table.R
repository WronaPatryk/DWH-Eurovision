## 1. Libraries & data load
library(dplyr)
df <- read.csv("../data/original/GDP_and_GDP_GROWTH.csv", sep = ";", stringsAsFactors = FALSE)

## 2. Numeric types
df[is.na(df)] <- 0
df$GDP.growth.annual <- as.numeric(gsub(",", ".", gsub("\\.", "", df$GDP.growth.annual)))
df$GDP.current.US <- as.numeric(gsub(",", ".", gsub("\\.", "", df$GDP.current.US)))

## 3. Growth annual column to categories
df$GDP.growth.annual <- cut(df$GDP.growth.annual, c(-100, -10, -5, -1, -0.001, 0.001, 1, 5, 10, 100))
df <- df %>%
  mutate(GDP.growth.annual.cat = case_when(
    GDP.growth.annual == "(-100,-10]" ~ "Huge decrease",
    GDP.growth.annual == "(-10,-5]" ~ "Big decrease",
    GDP.growth.annual == "(-5,-1]" ~ "Slight decrease",
    GDP.growth.annual == "(-1,-0.001]" ~ "Stagnation",
    GDP.growth.annual == "(-0.001,0.001]" ~ "Unknown",
    GDP.growth.annual == "(0.001,1]" ~ "Stagnation",
    GDP.growth.annual == "(1,5]" ~ "Slight increase",
    GDP.growth.annual == "(5,10]" ~ "Big increase",
    GDP.growth.annual == "(10,100]" ~ "Huge increase",
  )) %>%
  select(-GDP.growth.annual)

## 4. Current US column to categories
for (i in 1:nrow(df)){
  df$GDP.current.US[i] <- floor(log10(df$GDP.current.US[i])) + 1
}

df[df == -Inf] <- "Unknown"
#table(df$GDP.current.US)

## 5. Repair column names
colnames(df) <- c("Country", "Year", "Current.US.digits", "Growth.annual")

## 6. Save
write.csv2(df, "../data/new/gdp.csv", row.names = F)