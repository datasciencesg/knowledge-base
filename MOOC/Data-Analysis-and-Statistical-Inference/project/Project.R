#load data from URL
load(url("http://bit.ly/dasi_gss_data"))
View(gss)
str(gss)

#thesis topic
#1. how does education affect current income?  
#2. how does family income at 16 affect education?
#3. how does family income at 16 affect current income?
#4. is there an interaction effect between education and family income at 16 on current income?

#subsetting the data
gss1 <- subset(gss, select = c(caseid, year, age, sex, educ, degree, coninc, incom16))
View(gss1)

#variables to examine
#highest year of school completed
summary(gss$educ)

#highest education qualification
degree_table <- table(gss$degree)
degree_table
prop.table(degree_table)
plot(gss$degree)

#constant income
summary(gss$coninc)
hist(gss$coninc, xlab = "total family income")
?hist

#family income when 16 years old
fam_income <- table(gss$incom16)
prop.table (fam_income)

#exploratory analysis
model <- lm(gss$coninc ~ gss$degree)
summary(model)
plot(gss$coninc ~ gss$degree, xlab = "education level", ylab = "total family income")
anova(model)
plot(gss$coninc ~ gss$degree)

#create individual years
gss2012 <- subset(gss, year == 2012, select = c(caseid, year, age, sex, educ, degree, coninc, incom16))
gss2002 <- subset(gss, year == 2002, select = c(caseid, year, age, sex, educ, degree, coninc, incom16))
gss1993 <- subset(gss, year == 1993, select = c(caseid, year, age, sex, educ, degree, coninc, incom16))
gss1982 <- subset(gss, year == 1982, select = c(caseid, year, age, sex, educ, degree, coninc, incom16))

#create z-scores
conincz <- scale (gss1982$coninc)
gss2012 <- cbind(gss2012, conincz)
gss2002 <- cbind(gss2002, conincz)
gss1993 <- cbind(gss1993, conincz)
gss1982 <- cbind(gss1982, conincz)

#plots of income ~ education over the years
par(mfrow = c(2,2))
plot(gss2012$conincz ~ gss2012$degree, main = "2012", xlab = "education level", ylab = "total family income", ylim = c(-1.5,3))
plot(gss2002$conincz ~ gss2002$degree, main = "2002", xlab = "education level", ylab = "total family income", ylim = c(-1.5,3))
plot(gss1993$conincz ~ gss1993$degree, main = "1993", xlab = "education level", ylab = "total family income", ylim = c(-1.5,3))
plot(gss1982$conincz ~ gss1982$degree, main = "1982", xlab = "education level", ylab = "total family income", ylim = c(-1.5,3))

#plots of income ~ family income at 16
par(mfrow = c(2,2))
plot(gss2012$conincz ~ gss2012$incom16, main = "2012", xlab = "education level", ylab = "family income at 16", ylim = c(-1.5,3))
plot(gss2002$conincz ~ gss2002$incom16, main = "2002", xlab = "education level", ylab = "family income at 16", ylim = c(-1.5,3))
plot(gss1993$conincz ~ gss1993$incom16, main = "1993", xlab = "education level", ylab = "family income at 16", ylim = c(-1.5,3))
plot(gss1982$conincz ~ gss1982$incom16, main = "1982", xlab = "education level", ylab = "family income at 16", ylim = c(-1.5,3))

#degree over time
plot(gss2012$degree, main = "2012")
plot(gss2002$degree, main = "2002")
plot(gss1993$degree, main = "1993")
plot(gss1982$degree, main = "1982")

#exploratory analysis for 2012
#income ~ education level
model <- lm(gss2012$conincz ~ gss2012$degree)
summary(model)
plot(gss2012$conincz ~ gss2012$degree, xlab = "education level", ylab = "total family income")
anova(model)

#income ~ no. of years of education
model2 <- lm(gss2012$conincz ~ gss2012$educ)
summary(model2)
plot(gss2012$conincz ~ gss2012$educ, xlab = "education years", ylab = "total family income")
anova(model2)

#income ~ income at age 16
model3 <- lm(gss2012$conincz ~ gss2012$incom16)
summary(model3)
plot(gss2012$conincz ~ gss2012$incom16, xlab = "education years", ylab = "total family income")
anova(model3)

#income ~ education level + no. of years of education
model4 <- lm(gss2012$conincz ~ gss2012$degree + gss2012$educ)
summary(model4)
plot(gss2012$conincz ~ gss2012$degree + gss2012$educ, xlab = "education level", ylab = "total family income")
anova(model4)

#income ~ education level + income at age 16
model5 <- lm(gss2012$conincz ~ gss2012$degree + gss2012$incom16)
summary(model5)
plot(gss2012$conincz ~ gss2012$degree + gss2012$incom16, xlab = "education level", ylab = "total family income")
anova(model5)

#education level ~ income at age 16
model6 <- lm(gss2012$degree ~ gss2012$incom16)
summary(model6)
plot(gss2012$conincz ~ gss2012$degree + gss2012$incom16, xlab = "education level", ylab = "total family income")
anova(model6)

#chi-square of education level ~ family income at age 16
table1 <- table(gss2012$degree, gss2012$incom16)
table1
prop.table(table1)
chisq.test(table1)

#plot education level ~ income at 16
par(mfrow = c(2,2))
plot(gss2012$degree, gss2012$incom16)
plot(gss2012$incom16, gss2012$degree)
plot(gss2002$incom16, gss2002$degree)
plot(gss1993$incom16, gss1993$degree)
plot(gss1982$incom16, gss1982$degree)
