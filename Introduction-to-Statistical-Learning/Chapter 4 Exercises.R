### Chapter 4 Exercises
library(ISLR)

# Qn 10
str(Weekly)
wk <- Weekly

# 10.a
pairs(wk, col = wk$Direction)
cor(wk)
cor(select(wk, -Direction))
# volume and year have strong positive correlation, but little else for the 
# other variables

# 10.b
glm.fit <- glm(Direction ~. - Today, data = wk, family = binomial)
summary(glm.fit)
# Only Lag2 appears to be statistically significant

# 10.c
glm.prob <- predict(glm.fit, newdata = wk, type = 'response')
glm.pred <- rep('Down', 1089)
glm.pred[glm.prob > 0.5] <- 'Up'

# asssess accuracy
table(wk$Direction, glm.pred)
prop.table(table(wk$Direction, glm.pred), margin = 1)  # sensitivity = 0.922
prop.table(table(wk$Direction, glm.pred), margin = 2)  # precision = 0.566
mean(wk$Direction == glm.pred)  # overall 0.564

# 10.d
# creating traing and testing data
train <- wk %>%
  filter(Year < 2009)

test <- wk %>%
  filter(Year >= 2009)

glm.fit <- glm(Direction ~ Lag2, data = train, family = binomial)
glm.prob <- predict(glm.fit, newdata = test, type = 'response')
glm.pred <- rep('Down', 104)
glm.pred[glm.prob > 0.5] <- 'Up'

table(test$Direction, glm.pred)
prop.table(table(test$Direction, glm.pred), margin = 1)  # sensitivity = 0.92
mean(test$Direction == glm.pred)  # overall accuracy = 0.625

# 10.e
lda.fit <- lda(Direction ~ Lag2, data = train)
lda.pred <- predict(lda.fit, newdata = test)
str(lda.pred)

table(test$Direction, lda.pred$class)
prop.table(table(test$Direction, lda.pred$class), margin = 1) # sensitivity = 0.92
mean(test$Direction == lda.pred$class)  # overall accuracy = 0.625

# 10.f
qda.fit <- qda(Direction ~ Lag2, data = train)
qda.pred <- predict(qda.fit, newdata = test)

table(test$Direction, qda.pred$class)
prop.table(table(test$Direction, qda.pred$class), margin = 1) # sensitivity = 1
prop.table(table(test$Direction, qda.pred$class), margin = 2) # precision = 0.58
mean(test$Direction == qda.pred$class) # overall accuracy = 0.587

# 10.g
library(class)

# create feature data frame and class factors
train <- wk %>%
  filter(Year < 2009) %>%
  select(Lag2) 

train.class <- wk %>%
  filter(Year < 2009) %>%
  select(Direction)

train.class <- train.class$Direction

test <- wk %>%
  filter(Year >= 2009) %>%
  select(Lag2)

test.class <- wk %>%
  filter(Year >= 2009) %>%
  select(Direction)

test.class <- test.class$Direction

# create KNN predictions
knn.pred <- knn(train, test, train.class, k = 1)
 
table(test.class, knn.pred)
prop.table(table(test.class, knn.pred), margin = 1)  # sensitivity = 0.52
mean(test.class == knn.pred)  # overall accuracy = 0.51

# 10.h
Logistic regression and LDA seem to have the best error rates

# Qn 11
rm(list = ls())
auto <- Auto
str(auto)

# 11.a
auto <- auto %>%
  mutate(mpg01 = ifelse(mpg > median(auto$mpg), 1, 0))

# another way of doing it
auto$mpg02 <- 0
auto$mpg02[auto$mpg > median(auto$mpg)] = 1
auto <- select(auto, -mpg02)

# 11.b
pairs(auto) # displacement, weight, horsepower, and acceleration seem to have an effect on mpg01
cor(select(auto, -name))

boxplot(auto$displacement ~ auto$mpg01)
boxplot(auto$weight ~ auto$mpg01)
boxplot(auto$horsepower ~ auto$mpg01)
boxplot(auto$acceleration ~ auto$mpg01)

# 11.c
# add set factor for train and test set
auto <- auto %>%
  mutate(set = sample(c('train', 'test'), size = 392, replace = T, 
                        prob = c(0.75, 0.25)))

# create train and test set
train <- auto %>%
  filter(set == 'train')

test <- auto %>%
  filter(set == 'test')

# create lda.fit
lda.fit <- lda(mpg01 ~ displacement + weight + horsepower + acceleration, 
               data = train)
lda.pred <- predict(lda.fit, newdata = test)
table(test$mpg01, lda.pred$class)
prop.table(table(test$mpg01, lda.pred$class), margin = 1)
mean(test$mpg01 == lda.pred$class)  # overall accuracy = 0.86

# create qda.fit
qda.fit <- qda(mpg01 ~ displacement + weight + horsepower + acceleration, 
               data = train)
qda.pred <- predict(qda.fit, newdata = test)
table(test$mpg01, qda.pred$class)
prop.table(table(test$mpg01, qda.pred$class), margin = 1)
mean(test$mpg01 == qda.pred$class)  # overall accuracy = 0.86

# create glm.fit
glm.fit <- glm(factor(mpg01) ~ displacement + weight + horsepower + acceleration, 
               data = train, family = binomial)
glm.prop <- predict(glm.fit, newdata = test)
glm.pred <- rep(0, length(test$mpg01))
glm.pred[glm.prop > 0.5] <- 1
table(test$mpg01, glm.pred)
prop.table(table(test$mpg01, glm.pred), margin = 1)
mean(test$mpg01 == glm.pred) 

# create knn
library(class)

# create feature data frames and class factors
train <- auto %>%
  filter(set == 'train') %>%
  select(displacement, weight, horsepower, acceleration)

train.class <- auto %>%
  filter(set == 'train') %>%
  select(mpg01)

train.class <- train.class$mpg01

test <- auto %>%
  filter(set == 'test') %>%
  select(displacement, weight, horsepower, acceleration)

test.class <- auto %>%
  filter(set == 'test') %>%
  select(mpg01)

test.class <- test.class$mpg01

# create knn where k = 1
knn.pred <- knn(train, test, train.class, k = 1)
table(test.class, knn.pred)
mean(test.class == knn.pred)  # overall accuracy = 0.85

# create knn where k = 10
knn.pred <- knn(train, test, train.class, k = 10)
table(test.class, knn.pred)
mean(test.class == knn.pred)  # overall accuracy = 0.87

# create knn where k = 100
knn.pred <- knn(train, test, train.class, k = 100)
table(test.class, knn.pred)
mean(test.class == knn.pred)  # overall accuracy = 0.85

# create knn where k = 50
knn.pred <- knn(train, test, train.class, k = 50)
table(test.class, knn.pred)
mean(test.class == knn.pred)  # overall accuracy = 0.85

# Qn 12.a
Power <- function() {
  print(2^3)
}
  
# Qn 12.b
Power2 <- function(x, a) {
  print(x^a)
}

# Qn 12.c
Power2(10, 3)
Power2(8, 17)
Power2(131, 3)

# Qn 12.d
Power3 <- function(x, a) {
  result <- x^a
  return(result)
}

# Qn 12.e
x <- 1:10
plot(x, Power3(x, 2))
plot(x, Power3(x, 2),  log="xy", ylab="Log of y = x^2", xlab="Log of x",
     main="Log of x^2 versus Log of x")

# Qn 12.f
PlotPower <- function(x, a) {
  plot(x, Power3(x, a))
}
PlotPower(1:10, 3)

# Qn 13
rm(list = ls())
library(MASS)
bos <- Boston
str(bos)

# create crim01 variable
bos <- bos %>%
  mutate(crim01 = ifelse(crim > median(bos$crim), 1, 0))
str(bos)

# create train and test set
train <- bos %>%
  sample_frac(0.75)

test <- setdiff(bos, train)

# explore data
pairs(bos) # looks like indus, nox, rm, age, dist, rad,  tax, ptratio, black, lstat, and medv have effect
cor(bos)

# create glm.fit
glm.fit <- glm(crim01 ~ indus + nox + rm + age + dis + rad + tax + ptratio + 
                 black + lstat + medv, data = bos, family = binomial)
glm.prop <- predict(glm.fit, newdata = test, type = 'response')
glm.pred <- rep(0, length(glm.prop))
glm.pred[glm.prop > 0.5] <- 1
table(test$crim01, glm.pred)
prop.table(table(test$crim01, glm.pred), margin = 1)  # sensitivity = 0.92
mean(test$crim01 == glm.pred)  # accuracy = 0.94

# create lda.fit
lda.fit <- lda(crim01 ~ indus + nox + rm + age + dis + rad + tax + ptratio + 
                 black + lstat + medv, data = bos)
lda.pred <- predict(lda.fit, newdata = test)
lda.class <- lda.pred$class
table(test$crim01, lda.class)
prop.table(table(test$crim01, lda.class), margin = 1) # sensitivity = 0.73
mean(test$crim01 == lda.class)  # accuracy = 0.86

# create qda.fit
qda.fit <- qda(crim01 ~ indus + nox + rm + age + dis + rad + tax + ptratio + 
                 black + lstat + medv, data = bos)
qda.pred <- predict(qda.fit, newdata = test)
qda.class <- qda.pred$class
table(test$crim01, qda.class)
prop.table(table(test$crim01, qda.class), margin = 1) # sensitivity = 0.76
mean(test$crim01 == qda.class)  # accuracy = 0.87

# create knn fit, k = 10
train <- bos %>% 
  sample_frac(0.75) %>%
  select(-crim, -zn, -chas)

test <- bos %>%
  select(-crim, -zn, -chas) %>%
  setdiff(train)

train.class <- train$crim01
train <- select(train, -crim01)

test.class <- test$crim01
test <- select(test, -crim01)

library(class)
knn.pred <- knn(train, test, train.class, k = 10)
table(test.class, knn.pred)
prop.table(table(test.class, knn.pred), margin = 1) # sensitivity = 0.92
mean(test.class == knn.pred)  # accuracy = 0.90

# create knn fit, k = 20
knn.pred <- knn(train, test, train.class, k = 20)
table(test.class, knn.pred)
prop.table(table(test.class, knn.pred), margin = 1) # sensitivity = 0.94
mean(test.class == knn.pred)  # accuracy = 0.87
