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

## Verify current working directory ##
getwd()
setwd("Analysis//Data")
getwd()

## Download data ##
prodURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
educURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

download(prodURL, destfile = "GrossDomesticProduct.csv")
download(educURL, destfile = "Education.csv")

list.files() # Confirm download to working directory

#product <- read.csv("GrossDomesticProduct.csv")
#education <- read.csv("Education.csv")
#str(product)
#str(education)

## Import Gross Domestic Product data and review structure ##
productRaw <- read.csv("GrossDomesticProduct.csv", stringsAsFactors = FALSE, header = FALSE) # Try reading characters in as strings instead of factors for easier manipulation
str(productRaw) #Review data type row/column count
head(productRaw) #Review beginning rows
tail(productRaw, 100) #Review ending rows

product <- productRaw[6:236,]
str(product)
head(product)
tail(product)

## Check NA's in imported columns to identify empty columns ##
sum(!is.na(product[,c(3,7:10)])) #Detect total number of valid entries
c(sum(is.na(product$V3)), sum(is.na(product$V7)), sum(is.na(product$V8)), sum(is.na(product$V9)), sum(is.na(product$V10))) #Output NA counts

## Check character column suspected of having empty character entries
sum(product$V6 != "") #Check character type column for valid entries
sum(product$V6 == "") #Output empty entry counts

## Extract only valid columns from raw data
product <- product[,c(1,2,4:6)]

## Provide names for each column
names(product) <- c("Country","CountryRank", "Economy", "GDP_Millions_of_US_Dollars", "Comments")
head(product)

## Replace comment reference with comment from original data's legend
product[product$Comments != "",]
product$Comments[product$Comments == 'a'] <- "Includes Former Spanish Sahara"
product$Comments[product$Comments == 'b'] <- "Excludes South Sudan"
product$Comments[product$Comments == 'c'] <- "Covers mainland Tanzania only"
product$Comments[product$Comments == 'd'] <- "Data are for the area controlled by the government of the Republic of Cyprus"
product$Comments[product$Comments == 'e'] <- "Excludes Abkhazia and South Ossetia"
product$Comments[product$Comments == 'f'] <- "Excludes Transnistria"
product[product$Comments != "",]

## Convert GDP type to numeric
product$GDP_Millions_of_US_Dollars <- gsub(",","", product$GDP_Millions_of_US_Dollars, fixed = TRUE) # Prep GDP column for
product$GDP_Millions_of_US_Dollars <- gsub(".","", product$GDP_Millions_of_US_Dollars, fixed = TRUE) # type conversion
product$GDP_Millions_of_US_Dollars <- as.numeric(product$GDP_Millions_of_US_Dollars) # Convert GDP type to numeric

## Convert CountryRank type to integer
product$CountryRank <- as.integer(product$CountryRank)

## Output number of NA or empty values for each variable used in analysis
sum(product$Country == "")
sum(is.na(product$CountryRank))
sum(product$Economy == "")
sum(is.na(product$GDP_Millions_of_US_Dollars))
sum(product$Comments == "")

## Remove remaining NA values from product data frame
product <- product[complete.cases(product),]
str(product)
