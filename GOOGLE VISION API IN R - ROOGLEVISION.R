#Utilizing RoogleVision
# Normal Libraries
library(tidyverse)

# devtools::install_github("flovv/RoogleVision")
library(RoogleVision)
library(jsonlite) # to import credentials

# For image processing
# source("http://bioconductor.org/biocLite.R")
# biocLite("EBImage")
library(EBImage)

# For Latitude Longitude Map
library(leaflet)

#Google Authentication
#In order to use the API, you have to authenticate. There is plenty of documentation out there about how to setup an account, create a project, download credentials, etc. Head over to Google Cloud Console if you don’t have an account already.
# Credentials file I downloaded from the cloud console
creds<-fromJSON(file.choose())
creds<-fromJSON("My First Project-307a0c5e71b2.json")

# Google Authentication - Use Your Credentials
# options("googleAuthR.client_id" = "xxx.apps.googleusercontent.com")
# options("googleAuthR.client_secret" = "")
options("googleAuthR.client_id" = creds$installed$client_id)
options("googleAuthR.client_secret" = creds$installed$client_secret)
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))
library(googleCloudStorageR)
gcs_auth()
googleAuthR::gar_auth()
#options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/cloud-platform")
#library(googleCloudStorageR)
#gcs_auth()
googleAuthR::gar_set_client(file.choose())
library(googleCloudStorageR)
gcs_auth()

library(googleCloudStorageR)
## first time this will send you to the browser to authenticate
gcs_auth()

## to authenticate with a fresh user, delete .httr-oauth or run with new_user=TRUE
gcs_auth(new_user = TRUE)

#Auto-authentication
Sys.setenv("GCS_AUTH_FILE" = "My First Project-307a0c5e71b2.json")

## GCS_AUTH_FILE set so auto-authentication
library(googleCloudStorageR)

## no need for gcs_auth()
gcs_get_bucket("https://oauth2.googleapis.com/token")

#Label Detection: (This is used to help determine content within the photo. It can basically add a level of metadata around the image.
#Here is a photo of our dog when we hiked up to Audubon Peak in Colorado:)
us_label = getGoogleVisionResponse(file.choose(),feature = 'LABEL_DETECTION')
head(us_label)

#Landmark Detection: (This is a feature designed to specifically pick out a recognizable landmark! It provides the position in the image along with the geolocation of the landmark (in longitude and latitude).)
us_castle <- readImage(file.choose())
plot(us_castle)
display(us_castle)

#The response from the Google Vision API was spot on. It returned “Linderhof Palace” as the description. It also provided a score (I reduced the resolution of the image which hurt the score), a boundingPoly field and locations.
#Bounding Poly – gives x,y coordinates for a polygon around the landmark in the image.
#Locations – provides longitude,latitude coordinates.
us_landmark = getGoogleVisionResponse(file.choose(),
                                      feature = 'LANDMARK_DETECTION')
head(us_landmark)

#I plotted the polygon over the image using the coordinates returned. It does a great job (certainly not perfect) of getting the castle identified. It’s a bit tough to say what the actual “landmark” would be in this case due to the fact the fountains, stairs and grounds are certainly important and are a key part of the castle.
us_castle <- readImage(file.choose())
plot(us_castle)
xs = us_landmark$boundingPoly$vertices[[1]][1][[1]]
ys = us_landmark$boundingPoly$vertices[[1]][2][[1]]
polygon(x=xs,y=ys,border='red',lwd=4)

#Turning to the locations – I plotted this using the leaflet library. If you haven’t used leaflet, start doing so immediately. I’m a huge fan of it due to speed and simplicity. There are a lot of customization options available as well that you can check out.
#The location = spot on! While it isn’t a shock to me that Google could provide the location of “Linderhof Castle” – it is amazing to me that I don’t have to write a web crawler search function to find it myself! That’s just one of many little luxuries they have built into this API.
latt = us_landmark$locations[[1]][[1]][[1]]
lon = us_landmark$locations[[1]][[1]][[2]]
m = leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(lng = lon, lat = latt, zoom = 5) %>%
  addMarkers(lng = lon, lat = latt)
m

#Face Detection:
us_hats = getGoogleVisionResponse(file.choose(),
                                  feature = 'FACE_DETECTION')
head(us_hats)
xs1 = us_hats$fdBoundingPoly$vertices[[1]][1][[1]]
ys1 = us_hats$fdBoundingPoly$vertices[[1]][2][[1]]

xs2 = us_hats$fdBoundingPoly$vertices[[2]][1][[1]]
ys2 = us_hats$fdBoundingPoly$vertices[[2]][2][[1]]

polygon(x=xs1,y=ys1,border='red',lwd=4)
polygon(x=xs2,y=ys2,border='green',lwd=4)

#Here’s a shot that should be familiar (copied directly from my last blog) – and I wanted to highlight the different features that can be detected. Look at how many points are perfectly placed:
head(us_hats$landmarks)


