##############################
## Chris Boomhower
## MSDS 6306
## Unit 6 Case Study
## 06/11/2016
##############################

## Load required packages
require(ggplot2)
require(knitr)

## QUESTION 1: MATCH THE DATA BASED ON THE COUNTRY SHORTCODE. HOW MANY OF THE IDs MATCH?
## Merge Income and GDPdata
MergeData <- merge(Income, GDPdata, by = "Country.Code", all = TRUE)
str(MergeData) # Review raw data internal structure details
head(MergeData) # Review beginning rows to ensure no blank observations

## Indicate how many of the IDs match
length(intersect(GDPdata$Country.Code, Income$Country.Code))

## Indicate how many of the rows contain NAs
sum(!complete.cases(MergeData))

## Remove rows with missing data
MergeData1 <- MergeData[complete.cases(MergeData),]
nrow(MergeData1) # Provide row count after removing rows with missing data

## QUESTION 2: SORT THE DATA FRAME IN ASCENDING ORDER BY GDP (SO UNITED STATES IS LAST). WHAT IS THE 13TH COUNTRY IN THE RESULTING DATA FRAME?
MergeData1 <- MergeData1[order(MergeData1$GDP.Millions.of.US.Dollars, decreasing = FALSE),] # Sort the data frame by GDP
MergeData1$Short.Name[13] # Display only the 13th country in the data frame

## QUESTION 3: WHAT ARE THE AVERAGE GDP RANKINGS FOR THE "High income: OECD" AND "High income: nonOECD" GROUPS?
mean(subset(MergeData1, Income.Group == "High income: OECD")$Country.Rank)
mean(subset(MergeData1, Income.Group == "High income: nonOECD")$Country.Rank)

## QUESTION 4: PLOT THE GDP FOR ALL OF THE COUNTRIES. USE GGPLOT2 TO COLOR YOUR PLOT BY Income.Group
# MergeData1$Country.Code <- as.factor(MergeData1$Country.Code) # Convert Country.Code type to factor in order to reorder ggplot x-axis by Income.Group
# MergeData1$Country.Code <- factor(MergeData1$Country.Code, levels = MergeData1$Country.Code[order(MergeData1$GDP.Millions.of.US.Dollars)]) # Reorder Country.Code by Income.Group

ggplot(data = MergeData1, aes(x=Income.Group, y=GDP.Millions.of.US.Dollars, fill=Income.Group)) +
    geom_boxplot() +                                                                            # Create boxplots
    theme(axis.text.x = element_text(angle = 55, hjust = 1, size = 10)) +                       # Adjust X axis label size and position
    xlab("Income Group") + ylab("GDP (Millions of US Dollars)") + ggtitle("GDP for All Countries by Income Group") # Provide labels

ggplot(data = MergeData1, aes(x=Income.Group, y=log(GDP.Millions.of.US.Dollars), fill=Income.Group)) + # Re-plot log transformed GDP
    geom_boxplot() + stat_summary(fun.y=mean, geom="point", shape=23, size=3, fill="red") +     
    geom_jitter(shape=16, position=position_jitter(0.3)) +                                      # Add individual data points with jitter
    theme(axis.text.x = element_text(angle = 55, hjust = 1, size = 10)) +                       
    xlab("Income Group") + ylab("Log Transformed GDP (Millions of US Dollars)") + ggtitle("Log Transformed GDP for All Countries by Income Group") # Provide labels

## QUESTION 5: CUT THE GDP RANKING INTO 5 SEPARATE QUANTILE GROUPS. MAKE A TABLE VERSUS Income.Group. HOW MANY COUNTRIES ARE
## LOWER MIDDLE INCOME BUT AMONG THE 38 NATIONS WITH THE HIGHEST GDP?

## Create additional data frame and add quantile column
MergeData2 <- MergeData1
MergeData2$GDP.Quantile <- ntile(MergeData2$Country.Rank, 5) # Add 5 quantiles by Country.Rank to new GDP.Quantile column

## Generate table output
kable(MergeData2[,c(2:3,6)], format = "pandoc", caption = "Country GDP Quantiles vs. Country GDP Rank", align = 'l', row.names = FALSE)

## Count number of lower middle income countries
sum(MergeData2[(nrow(MergeData2)-37):nrow(MergeData2),]$Income.Group == "Lower middle income")
