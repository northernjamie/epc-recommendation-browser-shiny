
#libraries

library (rgdal) ; library(maptools) ; library(leaflet)

#Import the two data files certificates.csv and recommendations.csv

manccerts <read_csv("~/Projects/Propolis_Stuff_Non_Google_Drive/non-domestic-E08000003-Manchester/certificates.csv", col_types = cols(BUILDING_REFERENCE_NUMBER = col_character(), 
INSPECTION_DATE = col_date(format = "%Y-%m-%d"), 
LMK_KEY = col_character(), LODGEMENT_DATE = col_date(format = "%Y-%m-%d")))

mancrecs <- read_csv("~/Projects/Propolis_Stuff_Non_Google_Drive/non-domestic-E08000003-Manchester/recommendations.csv", 
col_types = cols(LMK_KEY = col_character()))

#merge the certs and recs file to show recommendations with certificate details

mergeddata <- merge(x = mancrecs,y=manccerts,by.x = 'LMK_KEY', by.y = 'LMK_KEY', all = TRUE)

###geocode the postcode data using the postcode lookup file

#Remove the spaces from the datafile
mergeddata$POSTCODE <- gsub(' ','',mergeddata$POSTCODE)

#remove spaces from the postcode file
all_postcodes2$V1 <- gsub(' ','',all_postcodes2$V1)

#Merge the tables to bring in Lat / Long

geomergeddata <- merge(x= mergeddata, y = all_postcodes2, by.x='POSTCODE', by.y='V1',all.x = TRUE)

###Write to a csv file for use in the Shiny App
write_csv(geomergeddata,file="mergeddata.csv")

#make the dataframe smaller in terms of number of columns

geomergeddata2 <- data.frame("Address" = geomergeddata$ADDRESS,
                             "Postcode" = geomergeddata$POSTCODE,
                             "X" = geomergeddata$X,
                             "Y" = geomergeddata$Y,
                             "Recommendation" = geomergeddata$RECOMMENDATION,
                             "RecommendationCode" = geomergeddata$RECOMMENDATION_CODE,
                             "Date" = geomergeddata$INSPECTION_DATE,
                             "Hash" = geomergeddata$CERTIFICATE_HASH,
                             "LocalAuthority" = geomergeddata$LOCAL_AUTHORITY_LABEL)





