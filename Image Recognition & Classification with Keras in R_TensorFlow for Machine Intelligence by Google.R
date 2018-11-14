#Load Packages:
library(EBImage)
library(keras)

#Read Image:
pics<-c('car1.jpg','car2.jpg','car3.jpg','car4.jpg','car5.jpg','car6.jpg','plane1.jpg','plane2.jpg','plane3.jpg','plane4.jpg','plane5.jpg','plane6.jpg')
mypic<-list()
for (i in 1:12) {mypic[[i]]<-readImage(pics[i])}

#Explore:
print(mypic[[1]])
display(mypic[[7]])
summary(mypic[[1]])
hist(mypic[[1]])
str(mypic[[1]])
str(mypic)

#Resize:
for (i in 1:12) {mypic[[i]]<-resize(mypic[[1]],28,28)}
str(mypic)

#Reshape:
for (i in 1:12) {mypic[[i]]<-array_reshape(mypic[[i]],c(28,28,3))}
str(28*28*3)

#Row Bind:
trainx<-NULL
for (i in 7:11) {trainx<-rbind(trainx,mypic[[i]])}
str(trainx)
testx<-rbind(mypic[6],mypic[7])
trainy<-c(0,0,0,0,1,1,1,1)
testy<-c(0,0,1,1)

#One hot encoding:
trainlabels<-to_categorical(trainy)
testlabels<-to_categorical(testy)

library(PythonInR)
library(tensorflow)
library(reticulate)

reticulate::py_module_available("keras")
reticulate::py_config()
help("initialize_python")
help("tensorflow")

data()
load("AirPassengers")

library(XLConnect)
df<-readWorksheetFromFile("D:/Abhijit/Daily Activity/Daily_Activity.xlsx",sheet =1)
