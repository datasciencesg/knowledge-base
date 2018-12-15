url <- 'https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD'
download.file(url, destfile = 'cameras.csv')

list.files()

cameraData <- read.table('cameras.csv', sep = ',', header = T)
View(cameraData)

url <- https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD
download.file(url, destfile = "cameras.xlsx")
dateDownloaded <- date()
install.packages("xlsx")
library(xlsx)
cameraData2 <- read.xlxs('cameras.xlsx', sheetIndex = 1, header = T)

install.packages('XML')
library(XML)
url <- 'http://www.w3schools.com/xml/simple.xml'
doc <- xmlTreeParse(url, useInternal = T)
View(doc)
rootNode <- xmlRoot(doc)
View(rootNode)
xmlName(rootNode)
names(rootNode)
rootNode[[1]][[1]]
xpathSApply(rootNode,'//name',xmlValue)

url <- 'https://api.github.com/users/eugeneyan/repos'
library(jsonlite)
jsonData <- fromJSON(url)
View(jsonData)

install.packages('data.table')
require(data.table)
DF <- data.frame(x=rnorm(9), y=rep(c('a','b','c'), each=3), z=rnorm(9))
DF

DT <- data.table(x=rnorm(9), y=rep(c('a','b','c'), each=3), z=rnorm(9))
View(DT)
tables()
DT[2]
DT[,z]
DT[DT$y == 'a']
DT[,3, with = F]
DT[, list(mean(x), sum(z))]
DT[, w:=z^2]
setkey(DT,y)
DT["a"]


DT = data.table(matrix(sample(c(0,1),5,rep=T),50,10))
DT
DT[, -3, with=F]
DT[, setdiff(colnames(DT), 'V3'), with = F]

DT <- data.table(x=c(T, T, F, T), y=1:4)
DT
DT[DT$x]
DT[!DT$x]

DT[x == T]
?data.table

# Playing with plyr
dd<-data.frame(matrix(rnorm(216),72,3),c(rep("A",24),rep("B",24),rep("C",24)),c(rep("J",36),rep("K",36)))
colnames(dd) <- c("v1", "v2", "v3", "dim1", "dim2")
View(dd)
ddply(dd, c("dim1", "dim2"), function(df)mean(df$v1))
ddply(dd, c("dim1","dim2"), function(df)c(mean(df$v1),mean(df$v2),mean(df$v3),sd(df$v1),sd(df$v2),sd(df$v3)))
