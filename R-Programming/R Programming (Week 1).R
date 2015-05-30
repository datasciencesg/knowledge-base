#Quizzes 
setwd("~/Eugene's/Coursera/R Programming/Git")
hw1 <- read.csv("hw1_data.csv")

x <- c(4, TRUE)
class(x)

x <- c(1,3, 5)
y <- c(3, 2, 10)
cbind(x, y)

x <- list(2, "a", "b", TRUE)
x[2]

x <- 1:4
y <- 2
x + y

x <- c(17, 14, 4, 5, 13, 12, 10)
x[x > 10] <- 4
x

names(hw1)
head(hw1)

tail(hw1)
check <- is.na(hw1$Ozone)
summary(hw1[!check,])
table(check)

sub <- hw1[hw1$Ozone > 31,][hw1$Temp > 90, ]
?subset
sub2 <- subset(hw1, Temp > 90 & Ozone > 31)
summary(sub2)
summary(hw1[, Month == 6])
summary(hw1[hw1$Month == "5", ])

#Assignments

install.packages("swirl")
library(swirl)
swirl()
Eugene

