# Qn 8
# a
college <- read.csv('College.csv')
View(college)

# b
rownames(college) <- college[,1]
college <- college[,-1]

# c.i
summary(college)

# ciii
pairs(college[, 1:10])

# c.iii
attach(college)
plot(Private, Outstate)

# c.iv
elite <- rep('No', nrow(college))
elite[college$Top10perc > 50] <- 'yes'
elite <- as.factor (elite)
college <- data.frame(college, elite)

# alternatively
college$elite <- NA
college$elite <- 'no'
college$elite[Top10perc > 50] <- 'yes'
college$elite <- as.factor(college$elite)
summary(college$elite)
plot(college$elite, college$Outstate)
View(college)
ggplot(data=college, aes(x=elite, y=Outstate)) +
    geom_boxplot()

# c.v
par(mfrow=c(2,2))
hist(Apps)
hist(Apps, breaks = 10)
par(mfrow=c(1,1))
plot(college$Top10perc, college$Grad.Rate)

# Qn 9
auto <- read.csv('Auto.csv', header = T, na.strings = '?')
auto <- na.omit(auto)
View(auto)
summary(auto)

# b
apply(auto[, 1:7], 2, range)
sapply(auto[, 1:7], range)

# c
sapply(auto[, 1:7], mean)
sapply(auto[, 1:7], sd)

# alternatively
auto %>% 
    select(1:7) %>%
    summarise_each(funs(mean, sd))

# d
newAuto <- auto[-c(10:85), ]
sapply(newAuto[, 1:7], range)
sapply(newAuto[, 1:7], mean)
sapply(newAuto[, 1:7], sd)

# e
pairs(auto)
plot(auto$mpg, auto$displacement) # mpg negatively correlated with displacement
cor(auto$mpg, auto$displacement)

# f
pairs(auto) # excluding name, most of the variables have some relationship with mpg

# Qn 10
library(MASS)

# b
pairs(Boston)
# nox is correlated with dis
# lstat is correlated with medv

# c
# nox, age, lstat, and medev are associated with per capita crime rate
plot(Boston$crim, Boston$ptratio)

# d
hist(Boston$crim[Boston$crim > 1], breaks = 25)
hist(Boston$tax)
hist(Boston$ptratio)

# e
View(Boston)
sum(Boston$chas) # 35 bound the river

# f
median(Boston$ptratio)

# g
min(Boston$medv, na.rm=TRUE)
t(subset(Boston, medv == min(Boston$medv)))

# using dplyr
Boston %>%
    filter(medv == min(medv, na.rm = T))

# h
Boston %>%
    filter(rm>7) %>%
    summarise (n = n())

Boston %>%
    filter(rm>8) %>%
    summarise (n = n()) 

Boston %>%
    filter(rm>8) %>%
    summary()