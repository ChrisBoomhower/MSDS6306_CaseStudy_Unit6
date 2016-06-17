##############################
## Chris Boomhower
## MSDS 6306
## Unit 6 Case Study
## 06/11/2016
##############################

## Load required packages
# require(downloader)
# require(ggplot2)
# require(tidyr)
require(dplyr)

## Verify current working directory
# getwd()
# setwd("Analysis//Data")
# getwd()

## Download data
educURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download(educURL, destfile = "Education.csv")

list.files() # Confirm download to working directory

## Import Educational data and review raw data
EducRaw <- read.csv("Education.csv", stringsAsFactors = FALSE, header = TRUE) # Try reading characters in as strings instead of factors for easier manipulation
str(EducRaw) # Review raw data internal structure details
head(EducRaw) # Review beginning rows to ensure no blank observations
tail(EducRaw) # Review ending rows to ensure no blank observations

## Rename CountryCode variable to match GDPdata's Country.Code
Education <- rename(EducRaw, Country.Code = CountryCode)

## Check NAs or missing values in columns of interest
nrow(Education[Education$Country.Code == "",])
nrow(Education[Education$Income.Group == "",])
nrow(Education[Education$Short.Name == "",])
# nrow(EducRaw)

## Remove missing Income.Group values and assign subset to new data frame
# Education <- subset(EducRaw, EducRaw$Income.Group != "")

## Extract CountryCode and Income.Group columns
# Income <- Education[,1:3]
Income <- Education[,c(1,3,31)]
head(Income)

nrow(Income[Income$Country.Code == "",]) # Confirm there are no missing Country.Code values in the data
# write.csv(Income, "Income_clean.csv", row.names = FALSE)
