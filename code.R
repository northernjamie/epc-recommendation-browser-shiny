
#Import the two data files certificates.csv and recommendations.csv

manccerts <read_csv("~/Projects/Propolis_Stuff_Non_Google_Drive/non-domestic-E08000003-Manchester/certificates.csv", col_types = cols(BUILDING_REFERENCE_NUMBER = col_character(), 
INSPECTION_DATE = col_date(format = "%Y-%m-%d"), 
LMK_KEY = col_character(), LODGEMENT_DATE = col_date(format = "%Y-%m-%d")))

mancrecs <- read_csv("~/Projects/Propolis_Stuff_Non_Google_Drive/non-domestic-E08000003-Manchester/recommendations.csv", 
col_types = cols(LMK_KEY = col_character()))

###geocode the postcode data using the postcode lookup file

#Remove the spaces from the datafile
mergeddata$POSTCODE <- gsub(' ','',mergeddata$POSTCODE)

#remove spaces from the postcode file
all_postcodes$V1 <- gsub(' ','',all_postcodes$V1)

#Merge the tables to bring in Lat / Long

geomergeddata <- merge(x= mergeddata, y = all_postcodes, by.x='POSTCODE', by.y='V1',all.x = TRUE)


#merge the certs and recs file to show recommendations with certificate details

mergeddata <- merge(x = mancrecs,y=manccerts,by.x = 'LMK_KEY', by.y = 'LMK_KEY', all.x = TRUE)

#pivot the mergeddata to get totals for each thing



