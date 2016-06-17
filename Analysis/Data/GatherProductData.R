##############################
## Chris Boomhower
## MSDS 6306
## Unit 6 Case Study
## 06/11/2016
##############################

## Load required packages
require(downloader)
#require(tidyr)

## Verify current working directory
# getwd()
# setwd("Analysis//Data")
# getwd()

## Download data
prodURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

download(prodURL, destfile = "GrossDomesticProduct.csv")

list.files() # Confirm download to working directory

#product <- read.csv("GrossDomesticProduct.csv")
#education <- read.csv("Education.csv")
#str(product)
#str(education)

## Import Gross Domestic Product data and review raw
productRaw <- read.csv("GrossDomesticProduct.csv", stringsAsFactors = FALSE, header = FALSE) # Try reading characters in as strings instead of factors for easier manipulation
str(productRaw) # Review raw data internal structure details
head(productRaw) # Review beginning rows to ensure no blank observations
tail(productRaw, 100) # Review ending rows to ensure no blank observations

product <- productRaw[6:236,] # Remove empty rows at beginning and end of productRaw data.frame
str(product) # Review raw data internal structure details once more
head(product) # Review beginning rows once more
tail(product) # Review ending rows once more

## Check NAs in imported columns to identify empty columns
sum(!is.na(product[,c(3,7:10)])) # Detect total number of valid entries
# paste("Column 3 NAs =", sum(is.na(product$V3))) # Output NA counts for empty columns
# paste("Column 7 NAs =", sum(is.na(product$V7)))
# paste("Column 8 NAs =", sum(is.na(product$V8)))
# paste("Column 9 NAs =", sum(is.na(product$V9)))
# paste("Column 10 NAs =", sum(is.na(product$V10)))

## Check character column suspected of having empty character entries
sum(product$V6 != "") # Check character type column for valid entries
sum(product$V6 == "") # Output empty entry counts

## Extract only valid columns from raw data
product <- product[,c(1,2,4:6)]

## Provide names for each column
names(product) <- c("Country.Code","Country.Rank", "Economy", "GDP.Millions.of.US.Dollars", "Comments")
names(product) # Ensure names added correctly

## Replace comment reference with comment from original data's legend
product[product$Comments != "",] # View valid comment column entries before edits
product$Comments[product$Comments == 'a'] <- "Includes Former Spanish Sahara"
product$Comments[product$Comments == 'b'] <- "Excludes South Sudan"
product$Comments[product$Comments == 'c'] <- "Covers mainland Tanzania only"
product$Comments[product$Comments == 'd'] <- "Data are for the area controlled by the government of the Republic of Cyprus"
product$Comments[product$Comments == 'e'] <- "Excludes Abkhazia and South Ossetia"
product$Comments[product$Comments == 'f'] <- "Excludes Transnistria"
product[product$Comments != "",] # View valid comment column entries after edits

## Convert GDP type to numeric
product$GDP.Millions.of.US.Dollars <- gsub(",","", product$GDP.Millions.of.US.Dollars, fixed = TRUE) # Prep GDP column for
product$GDP.Millions.of.US.Dollars <- gsub(".","", product$GDP.Millions.of.US.Dollars, fixed = TRUE) # type conversion
product$GDP.Millions.of.US.Dollars <- as.numeric(product$GDP.Millions.of.US.Dollars) # Convert GDP type to numeric

## Convert Country.Rank type to integer
product$Country.Rank <- as.integer(product$Country.Rank)

## Output number of NA or empty values for each variable used in analysis
# sum(product$Country.Code == "")
# sum(is.na(product$Country.Rank))
# sum(product$Economy == "")
# sum(is.na(product$GDP.Millions.of.US.Dollars))
# sum(product$Comments == "")

product[!complete.cases(product),] # View all rows for which not all variable data is available

## Remove missing Country.Code values from the data frame
# product <- product[complete.cases(product),]
# str(product)
product1 <- subset(product, product$Country.Code != "")
# product1 <- subset(product1, !is.na(product1$GDP.Millions.of.US.Dollars))

## Extract only Country.Code and GDP column data to be merged
GDPdata <- product1[,c(1,2,4)]
str(GDPdata) # Review extracted data internal structure details
nrow(GDPdata[!complete.cases(GDPdata$Country.Code),]) # Confirm there are no missing Country.Code values in the data

GDPdata <- GDPdata[order(GDPdata$Country.Code),] # Order the data by Country.Code instead of GDP

# write.csv(GDPdata, "Product_clean.csv", row.names = FALSE)
