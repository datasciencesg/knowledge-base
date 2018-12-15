# Best.R function
outcome <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
View(outcome)

ncol(outcome)
names(outcome)
outcome[, 11] <- as.numeric(outcome[,11])
hist(outcome[,11])

Outcome <- 'heart failure'
State <- 'AK'

outcome_data <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
outcome_data <- outcome_data[c(2, 7, 11, 17, 23)]
names(outcome_data) <- c('hospital', 'state', 'heart attack', 'heart failure', 'pneumonia')
head(outcome_data, 50)
state_outcome <- subset(outcome_data, state == State)
state_outcome
score <- state_outcome[,Outcome]
score
hospital_row <- which.min(score)
hospital_row
state_outcome$hospital[hospital_row]

source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript3.R")
submit()

# RankHospital.R function
rm(list = ls())
Outcome <- 'heart failure'
State <- 'TX'
Num <- 4

outcome_data <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
outcome_data <- outcome_data[c(2, 7, 11, 17, 23)]
names(outcome_data) <- c('hospital', 'state', 'heart attack', 'heart failure', 'pneumonia')
head(outcome_data, 50)
outcome_data <- subset(outcome_data, state == State)
View(outcome_data)
outcome_data[Outcome]
outcome_data[Outcome] <- as.data.frame(sapply(outcome_data[Outcome], as.numeric))
View(outcome_data)
outcome_data <- outcome_data[order(outcome_data$hospital, decreasing = FALSE), ]
View(outcome_data)
outcome_data <- outcome_data[order(outcome_data[Outcome], decreasing = FALSE), ]
View(outcome_data)
outcome_data <- subset(outcome_data, state == State)
outcome_data
score <- outcome_data[,Outcome]
View(score)
hospital_row <- Num
hospital_row
state_outcome$hospital[hospital_row]
?order