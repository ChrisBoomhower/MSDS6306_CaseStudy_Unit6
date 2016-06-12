##############################
## Chris Boomhower
## MSDS 6306
## Unit 6 Case Study
## 06/11/2016
##############################

## QUESTION 1: MATCH THE DATA BASED ON THE COUNTRY SHORTCODE. HOW MANY OF THE IDs MATCH?
## Merge Income and GDPdata
MergeData <- merge(Income, GDPdata, by = "CountryCode", all = TRUE)
str(MergeData)
head(MergeData)

## Indicate how many of the IDs match
sum(complete.cases(MergeData))

MergeData1 <- MergeData[complete.cases(MergeData),]

## QUESTION 2: SORT THE DATA FRAME IN ASCENDING ORDER BY GDP (SO UNITED STATES IS LAST)
MergeData1 <- MergeData1[order(MergeData1$GDP_Millions_of_US_Dollars, decreasing = FALSE),]
MergeData1[13,]

## QUESTION 3: WHAT ARE THE AVERAGE GDP RANKINGS FOR THE "High income: OECD" AND "High income: nonOECD" GROUPS?
mean(subset(MergeData1, Income.Group == "High income: OECD")$GDP_Millions_of_US_Dollars)
mean(subset(MergeData1, Income.Group == "High income: nonOECD")$GDP_Millions_of_US_Dollars)

## QUESTION 4: PLOT THE GDP FOR ALL OF THE COUNTRIES. USE GGPLOT2 TO COLOR YOUR PLOT BY Income.Group
MergeData1$CountryCode <- as.factor(MergeData1$CountryCode) # Convert CountryCode type to factor in order to reorder ggplot x-axis by Income.Group
MergeData1$CountryCode <- factor(MergeData1$CountryCode, levels = MergeData1$CountryCode[order(MergeData1$GDP_Millions_of_US_Dollars)]) # Reorder CountryCode by Income.Group

ggplot(data = MergeData1, aes(x=CountryCode, y=GDP_Millions_of_US_Dollars, fill=Income.Group)) +
    geom_bar(stat = "identity") +                                                                # Plot bar chart
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.3, size = 7)) +
    xlab("Country Code (Ordered by GDP)") + ylab("GDP (In Millions of US Dollars)") + ggtitle("GDP for All Countries")

## QUESTION 5: CUT THE GDP RANKING INTO 5 SEPARATE QUANTILE GROUPS. MAKE A TABLE VERSUS Income.Group. HOW MANY COUNTRIES ARE
## LOWER MIDDLE INCOME BUT AMONG THE 38 NATIONS WITH THE HIGHEST GDP?
MergeData2 <- MergeData1
#sum(MergeData1$GDP_Millions_of_US_Dollars)/5
stepSize <- nrow(MergeData2)/5
MergeData2["GDP_Rank"] <- nrow(MergeData2):1
MergeData2$GDP_Quantile[MergeData2$GDP_Rank <= stepSize] <- "Quantile 5"
MergeData2$GDP_Quantile[MergeData2$GDP_Rank > stepSize & MergeData2$GDP_Rank <= 2*stepSize] <- "Quantile 4"
MergeData2$GDP_Quantile[MergeData2$GDP_Rank > 2*stepSize & MergeData2$GDP_Rank <= 3*stepSize] <- "Quantile 3"
MergeData2$GDP_Quantile[MergeData2$GDP_Rank > 3*stepSize & MergeData2$GDP_Rank <= 4*stepSize] <- "Quantile 2"
MergeData2$GDP_Quantile[MergeData2$GDP_Rank > 4*stepSize] <- "Quantile 1"
head(MergeData2, 40)
tail(MergeData2, 40)

MergeData2$GDP_Rank <- NULL # Delete the temporary GDP_Rank column
names(MergeData2)

tail(MergeData2, 38)## Display top 38 GDP contries (STILL NEED TO OUTPUT TO TABLE PER THE QUESTION)
sum(MergeData2[(nrow(MergeData2)-37):nrow(MergeData2),]$Income.Group == "Lower middle income") # Count number of lower middle income countries
