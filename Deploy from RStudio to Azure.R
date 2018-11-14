# packages used: 
# install.packages("RCurl")
# install.packages("plyr")
# install.packages("randomForest"): https://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm
# install.packages("AzureML"): https://github.com/RevolutionAnalytics/AzureML
# install RTools : https://cran.r-project.org/bin/windows/Rtools/

# Get IRIS dataset:
library(RCurl)

# Get data from UC Irvine ML Databases:
iris_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
iris_txt = getURL(iris_url)
iris_data = read.csv(textConnection(iris_txt), header = FALSE)

#Rename the columns:
library(plyr)
names(iris_data)
iris = rename(iris_data, c("V1"="Sepal_Length", "V2"="Sepal_Width","V3"="Petal_Length", "V4"="Petal_Width", "V5"="Species"))
names(iris)
irisInputs = iris[,-5]

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


print(mypredict(iris))


if(!require("devtools")) install.packages("devtools")
devtools::install_github("RevolutionAnalytics/azureml")

# Get Workspace ID  and Authorization from ML studio:
library(AzureML)
library(devtools)

wsID = "<Workspace ID>"
wsAuth = "<Workspace Authorization Token>"

wsobj = workspace(wsID,wsAuth)

# Create REST API:

irisWebService <- publishWebService(
  wsobj,
  fun = mypredict, 
  name = "irisWebService", 
  inputSchema = irisInputs
)
head(irisWebService)