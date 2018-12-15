#Qn 1 & 2
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(url, 'house.csv', method='curl')
house <- read.csv('house.csv')
View(house)
View(subset(house, house$VAL == 24))
sum(house$VAL==24, na.rm = T)
table(house$VAL)
View(house$VAL==24)
View(house[house$VAL==24, ])

#Qn 3
install.packages('xlsx')
install.packages('xlsxjars')
install.packages('rJava')
library(xlsx)
url  <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
download.file(url, 'gas.xlsx', method = 'curl', mode = 'wb')
colI <- 7:15
rowI <- 18:23
gas  <- read.xlsx('gas.xlsx', sheetIndex = 1, colIndex = colI, rowIndex = rowI)
sum(gas$Zip*gas$Ext,na.rm=T) 

#Qn 4
install.packages('XML')
library(XML)
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(url, useInternal = T)
rootNode <- xmlRoot(doc)
rootNode[1]
zip <- xpathSApply(doc, '//zipcode', xmlValue)
length(zip[zip==21231])

#Qn 5
install.packages('data.table')
library(data.table)
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(url, 'commune.csv', method = 'curl')
file <- tempfile()
write.table(DT, file = file, row.names = F, col.names = T, sep = ',', quote = F)
DT <- fread('commune.csv')

install.packages('microbenchmark')
library(microbenchmark)

f1 <- function(x) {
  DT[,mean(pwgtp15),by=SEX]
}

f2 <- function(x) {
  sapply(split(DT$pwgtp15,DT$SEX),mean)
}

f3 <- function(x) {
  mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
}

f4 <- function(x) {
  tapply(DT$pwgtp15,DT$SEX,mean)
}

microbenchmark(f1(x), f2(x), f3(x), f4(x))
