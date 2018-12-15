### Cross-Validation and the Bootstrap
# Validation set approach
library(ISLR)
library(boot)
set.seed(1)

auto <- Auto

# create training and testing sets
train <- auto %>%
  sample_frac(0.5)

test <- setdiff(auto, train)

# create linear model
lm.fit <- lm(mpg ~ horsepower, data = train)

# calculate MSE on the test set
mean((test$mpg - predict(lm.fit, newdata = test))^2)

# create and test quadratic regression
lm.fit2 <- lm(mpg ~ poly(horsepower, 2), data = train)
mean((test$mpg - predict(lm.fit2, test))^2)

# create and test cubic regression
lm.fit3 <- lm(mpg ~ poly(horsepower, 3), data = train)
mean((test$mpg - predict(lm.fit3, test))^2)

# Leave-One-Out Cross Validation
glm.fit <- glm(mpg ~ horsepower, data = auto)
cv.err <- cv.glm(auto, glm.fit)

# examine CV estimate of prediction error
cv.err$delta

# create and test polynomial regressions
cv.err <- rep(0, 5)
for (i in 1:5) {
  glm.fit = glm(mpg ~ poly(horsepower, i), data = auto)
  cv.err[i] = cv.glm(auto, glm.fit)$delta[1]
}
cv.err
degree <- 1:5

# plot error rates across varying polynomials
plot(degree, cv.err, type = 'b')

# k-Fold Cross-Validation
set.seed(3)
cv.err <- rep(0, 10)
for (i in 1:10) {
  glm.fit <- glm(mpg ~ poly(horsepower, i), data = auto)
  cv.err[i] = cv.glm(auto, glm.fit, K = 10)$delta[1]
}
cv.err
degree <- 1:10

# plot error rates 
plot(degree, cv.err, type = 'b')

### Bootstrap
port <- Portfolio

# create alpha function (as described in Section 5.2)
alpha.fn <- function(data, index) {
  X <- data$X[index]
  Y <- data$Y[index]
  return((var(Y) - cov(X, Y))/(var(X) + var(Y) - 2 * cov(X, Y)))
}
alpha.fn(port, 1:100)
set.seed(1)
alpha.fn(port, sample(100, 100, replace = T))

# create bootstrap estimates
boot(port, alpha.fn, R = 1000)

# Using bootstrap to estimate accuracy of linear regression model
boot.fn <- function(data, index) {
  return(coef(lm(mpg ~ horsepower, data = data, subset = index)))
}

boot.fn(Auto, 1:392)
set.seed(1)
boot.fn(Auto, sample(392, 392, replace = T))

# compute standard errors of 1000 bootstrap estimates
boot(Auto, boot.fn, 1000)

# compute standard errors from summar function
summary(lm(mpg ~ horsepower, data = Auto))  # read pg 196 for the difference between the bootstrap and the summary from lm

# compute bootstrap and summary using quadratic model
boot.fn <- function(data, index) {
  return(coef(lm(mpg ~ horsepower + I(horsepower^2), data = data, subset = index)))
}
set.seed(1)
boot(Auto, boot.fn, 1000)

summary(lm(mpg ~ horsepower + I(horsepower^2), data = Auto))

knitr::spin("~/Eugene's/Learning/Statistical Learning/Statistical Learning/Chapter 5 Labs.R")

