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
library(magick)
library(ggplot2)
library(scales)

# For Latitude Longitude Map
library(leaflet)

#Google Authentication
#In order to use the API, you have to authenticate. There is plenty of documentation out there about how to setup an account, create a project, download credentials, etc. Head over to Google Cloud Console if you don’t have an account already.
# Credentials file I downloaded from the cloud console
creds<-fromJSON(file.choose())
creds<-fromJSON("My First Project-307a0c5e71b2.json")#another way

# Google Authentication - Use Your Credentials
# options("googleAuthR.client_id" = "xxx.apps.googleusercontent.com")
# options("googleAuthR.client_secret" = "")
options("googleAuthR.client_id" = creds$installed$client_id)
options("googleAuthR.client_secret" = creds$installed$client_secret)
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))

#Auto-authentication
Sys.setenv("GCS_AUTH_FILE" = "My First Project-307a0c5e71b2.json")
library(googleCloudStorageR)
gcs_auth()

Sys.setenv(kairos_id = "f5267bea")
Sys.setenv(kairos_key = "2fbe4aff872a47fce1b359436f92d6ef")
library(facerec)
#You only need to call facerec_init() once after loading the package.
facerec_init()

us_castle <- readImage(file.choose())
us_faces <- detect(image = us_castle)
plot(us_castle)
display(us_castle)

#Label Detection: (This is used to help determine content within the photo. It can basically add a level of metadata around the image.
#Here is a photo of our dog when we hiked up to Audubon Peak in Colorado:)
us_label = getGoogleVisionResponse(file.choose(),feature = 'LABEL_DETECTION')
head(us_label)
head(us_label$score)

#Landmark Detection: (This is a feature designed to specifically pick out a recognizable landmark! It provides the position in the image along with the geolocation of the landmark (in longitude and latitude).)

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

#Face Detection:
my_face = getGoogleVisionResponse(file.choose(),
                                  feature = 'FACE_DETECTION')
head(my_face)
xs1 = my_face$fdBoundingPoly$vertices[[1]][1][[1]]
ys1 = my_face$fdBoundingPoly$vertices[[1]][2][[1]]

xs2 = my_face$fdBoundingPoly$vertices[[2]][1][[1]]
ys2 = my_face$fdBoundingPoly$vertices[[2]][2][[1]]

polygon(x=xs1,y=ys1,border='red',lwd=4)
polygon(x=xs2,y=ys2,border='green',lwd=4)

#Here’s a shot that should be familiar (copied directly from my last blog) – and I wanted to highlight the different features that can be detected. Look at how many points are perfectly placed:
head(us_hats$landmarks)

#Logo Detection:
#To continue along the Chicago trip, we drove by Wrigley field and I took a really bad photo of the sign from a moving car as it was under construction. It’s nice because it has a lot of different lines and writing the Toyota logo isn’t incredibly prominent or necessarily fit to brand colors.
us_logo = getGoogleVisionResponse(file.choose(),
                                  feature = 'LOGO_DETECTION')
head(us_logo)