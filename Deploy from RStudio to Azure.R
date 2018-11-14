# packages used: 
# install.packages("RCurl")
# install.packages("plyr")
# install.packages("randomForest"): https://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm
# install.packages("AzureML"): https://github.com/RevolutionAnalytics/AzureML
# install RTools : https://cran.r-project.org/bin/windows/Rtools/
install_cran("https://cran.r-project.org/bin/windows/Rtools/")

# Get IRIS dataset:
library(RCurl)

# Get data from UC Irvine ML Databases:
iris_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
iris_txt = getURL(iris_url)
iris_data = read.csv(textConnection(iris_txt), header = FALSE)
View(iris)
View(iris_data)

#Rename the columns:
library(plyr)
names(iris_data)
iris = rename(iris_data, c("V1"="Sepal_Length", "V2"="Sepal_Width","V3"="Petal_Length", "V4"="Petal_Width", "V5"="Species"))
names(iris)
irisInputs = iris[,-5]
View(irisInputs)

# Use Random Forest: 
library(randomForest)
model = randomForest(Species ~ ., 
                     data = iris,
                     method = "class"
)

summary(model)
plot(model)

# Create fucntion from model to be uploaded to Azure Machine Learning Webservice:
mypredict <- function(newdata)
{
  require(randomForest) #must be included see AzureML documentation
  predict(model, newdata, type = "response")
}


 


if(!require("devtools")) install.packages("devtools")
devtools::install_github("RevolutionAnalytics/azureml")

# Get Workspace ID  and Authorization from ML studio:
library(AzureML)
library(devtools)

wsID = "83db3a02a93f4322b9145667b9b30c18"
wsAuth = "9LDsmjFujxbyxzT19Mh58e364j8Rd9M2//eDSJsyqhTK+7x9Ain1an1iDXPvEONzDlCrESeTeGJ4ParRld/E6w=="

wsobj = workspace(wsID,wsAuth)

# Create REST API:
library(zipR)
irisWebService <- publishWebService(
                                    wsobj,
                                    fun = mypredict, 
                                    name = "irisWebService", 
                                    inputSchema = irisInputs
)
head(irisWebService)