#Qn 1
cube <- function(x, n) {
    x^3
}

#Qn 2
x <- 1:10
if(x > 5) {
    x <- 0
}
x

#Qn 3
f <- function(x) {
    g <- function(y) {
        y + z
    }
    z <- 4
    x + g(x)
}
z <- 10
f(3)

#Qn 4
x <- 5
y <- if(x < 3) {
    NA
} else {
    10
}
y

#Qn 5
h <- function(x, y = NULL, d = 3L) {
    z <- cbind(x, d)
    if(!is.null(y))
        z <- z + y
}

# Programming Assignment Part 1
directory <- ("specdata")
id <- 70:72
pollutant <- "sulfate"

filenames <- list.files(directory)
filenames <- filenames[id]
filenames <- paste(directory, "//", filenames, sep = "")
all_data <- data.frame(Date = numeric(), sulphate = numeric(), nitrate = numeric(), ID = numeric())
# sapply(id, rbind(all_data, read.csv(filenames)))

for (i in 1:length(id)) {
    all_data <- rbind(all_data, read.csv(filenames[i]))
}
mean(all_data[, pollutant], na.rm = T)
summary(all_data)

pollutantmean <- function(directory, pollutant, id = 1:332) {
    filenames <- list.files(directory)
    filenames <- filenames[id]
    filenames <- paste(directory, "//", filenames, sep = "")
    all_data <- data.frame(Date = numeric(), sulphate = numeric(), nitrate = numeric(), ID = numeric())
    for (i in 1:length(id)) {
        all_data <- rbind(all_data, read.csv(filenames[i]))
    }
    mean(all_data[, pollutant], na.rm = T)   
}

# Programming Assignment Part 2
rm(list = ls())
directory <- ("specdata")
ids <- c(2, 4, 6, 8, 10)
id <- numeric(length(ids))
nobs <- numeric(length(ids))
filenames <- list.files(directory)
filenames <- filenames[id]
filenames <- paste(directory, "//", filenames, sep = "")
for (i in 1:length(ids)) {
    id[i] <- ids[i]
    nobs[i] <- sum(complete.cases(read.csv(filenames[i])))
}
data.frame(id, nobs, stringsAsFactors = F)


complete <- function(directory, ids = 1:332) {
    filenames <- list.files(directory)
    filenames <- filenames[ids]
    filenames <- paste(directory, "//", filenames, sep = "")
    id <- numeric(length(ids))
    nobs <- numeric(length(ids))
    for (i in 1:length(ids)) {
        id[i] <- ids[i]
        nobs[i] <- sum(complete.cases(read.csv(filenames[i])))
    }
    data.frame(id, nobs, stringsAsFactors = F)
}

# Programming Assignment Part 3
threshold <- 1000
directory <- "specdata"
source("complete.R")

filenames <- list.files(directory)
filenames <- paste(directory, "//", filenames, sep = "")
all_files <- complete(directory)
cor_vector <- numeric()
for (i in 1:nrow(all_files)) {
    if (all_files[i,2] > threshold) {
        cor_vector <- c(cor_vector, cor(read.csv(filenames[i])$sulfate, read.csv(filenames[i])$nitrate, use = "pairwise.complete.obs")) 
    }
}
cor_vector

corr <- function(directory, threshold = 0) {
    filenames <- list.files(directory)
    filenames <- paste(directory, "//", filenames, sep = "")
    all_files <- complete(directory)
    cor_vector <- numeric()
    for (i in 1:nrow(all_files)) {
        if (all_files[i,2] > threshold) {
            cor_vector <- c(cor_vector, cor(read.csv(filenames[i])$sulfate, read.csv(filenames[i])$nitrate, use = "pairwise.complete.obs")) 
        }
    }
    cor_vector
}

source("complete.R")
source("corr.R")
rm(list = ls())
source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript1.R")
CLASS <- c("rprog-003")
submit.url <- c("http://class.coursera.org/rprog-003/assignment/submit")
challenge.url <- c("http://class.coursera.org/rprog-003/assignment/challenge")
submit()
