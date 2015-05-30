#load data from URL
load(url("http://bit.ly/dasi_gss_data"))
View(gss)
str(gss)
summary(gss)

#subset data for 2012
gss2012a <- subset(gss, year == 2012, select = c(caseid, year, age, sex, educ, degree, coninc, incom16))
gss2012 <- gss2012a[complete.cases(gss2012a), ]
summary(gss2012)

#R markdown template
download.file(url = "http://bit.ly/dasi_project_template", destfile = "dasi_project_template.Rmd")

#inference function
source("http://bit.ly/dasi_inference")
#load libraries
library(psych)
library(lattice)
library(ggplot2)

#thesis topic
#1. how does education affect current income?  
#2. how does family income at 16 affect education?
#3. how does family income at 16 affect current income?
#4. is there an interaction effect between education and family income at 16 on current income?

#Exploratory Data Analysis
#degree
summary(gss2012$degree)
table(gss2012$degree)
prop.table(table(gss2012$degree))
barplot(table(gss2012$degree))
by(gss2012$coninc, gss2012$degree, quantile)

#income
summary(gss2012$coninc)
hist(gss2012$coninc)
hist(gss2012$coninc, breaks = 20)
by(gss2012$coninc, gss2012$degree, quantile)

#overlapping plots of income by education
g <- ggplot(gss2012, aes(coninc))
g + geom_histogram(aes(y = ..density..), binwidth = 5000, colour = "black", fill = "white") + geom_density() + labs(title = "Distribution of income in 2012") + labs(x = "Total Family Income", y = "Density")

g <- ggplot(gss2012, aes(coninc, fill = degree))
g + geom_density (alpha = 0.2) + labs(title = "Income Level distributions across Education Levels") + labs(x = "Total Family Income", y = "Density")

g <- ggplot(gss2012, aes(coninc, fill = sex))
g + geom_density (alpha = 0.2) + labs(title = "Income Level distributions across Gender") + labs(x = "Total Family Income", y = "Density") + scale_fill_manual( values = c("#0066FF","#FF0099"))

#boxplot of income vs degree
par(mfrow = c(1,1))
boxplot(gss2012$coninc ~ gss2012$degree, xlab = "Education Level", ylab = "Total Family Income", main = "Boxplot of Total Family Income by Education Level")

#conditions
par(mfrow = c(1,5))
qqnorm(gss2012$coninc[gss2012$degree == "Lt High School"], main = "Lt High School")
qqline(gss2012$coninc[gss2012$degree == "Lt High School"])
qqnorm(gss2012$coninc[gss2012$degree == "High School"], main = "High School")
qqline(gss2012$coninc[gss2012$degree == "High School"])
qqnorm(gss2012$coninc[gss2012$degree == "Junior College"], main = "Junior College")
qqline(gss2012$coninc[gss2012$degree == "Junior College"])
qqnorm(gss2012$coninc[gss2012$degree == "Bachelor"], main = "Bachelor")
qqline(gss2012$coninc[gss2012$degree == "Bachelor"])
qqnorm(gss2012$coninc[gss2012$degree == "Graduate"], main = "Graduate")
qqline(gss2012$coninc[gss2012$degree == "Graduate"])

#anova of gss2012$coninc ~ gss2012$degree
inference(y = gss2012$coninc, x = gss2012$degree, est = "mean", type = "ht", null = 0, alternative = "greater", method = "theoretical")

inference(y = gss2012$coninc, x = gss2012$degree, est = "median", type = "ht", null = 0, alternative = "greater", method = "theoretical")

#anova of gss2012$coninc ~ gss2012$incom16
inference(y = gss2012$coninc, x = gss2012$incom16, est = "mean", type = "ht", null = 0, alternative = "greater", method = "theoretical")

inference(y = gss2012$coninc, x = gss2012$incom16, est = "median", type = "ht", null = 0, alternative = "greater", method = "theoretical")

#two sample t-test of gss2012$coninc ~ gss2012$sex
inference(y = gss2012$coninc, x = gss2012$sex, est = "mean", type = "ht", null = 0, alternative = "twosided", method = "theoretical")

#regression models
#current income ~ education level
model1 <- lm(gss2012$coninc ~ gss2012$degree)
summary(model1)

#current income ~ income at age of 16
model2 <- lm(gss2012$coninc ~ gss2012$incom16)
summary(model2)

#current income ~ sex
model3 <- lm(gss2012$coninc ~ gss2012$sex)
summary(model3)

#current income ~ age
model4 <- lm(gss2012$coninc ~ gss2012$age)
summary(model4)

#current income ~ education level + income at age of 16 + sex
model5 <- lm(gss2012$coninc ~ gss2012$degree + gss2012$incom16 + gss2012$sex)
summary(model5)

?aov
