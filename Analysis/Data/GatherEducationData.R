##############################
## Chris Boomhower
## MSDS 6306
## Unit 6 Case Study
## 06/11/2016
##############################

## Load required packages
require(downloader)
require(ggplot2)
require(tidyr)

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
str(EducRaw) #Review data type row/column count
head(EducRaw) #Review beginning rows
tail(EducRaw, 100) #Review ending rows

## Check NAs or missing values in columns of interest
nrow(EducRaw[EducRaw$CountryCode == "",])
nrow(EducRaw[EducRaw$Income.Group == "",])
nrow(EducRaw[EducRaw$Long.Name == "",])
nrow(EducRaw)

## Remove missing Income.Group values and assign subset to new data frame
Education <- subset(EducRaw, EducRaw$Income.Group != "")

## Extract CountryCode and Income.Group columns
Income <- Education[,1:3]
head(Income)

Income[complete.cases(Income),]
write.csv(Income, "Income_clean.csv", row.names = FALSE)
