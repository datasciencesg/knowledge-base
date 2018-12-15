### Qn 4
library(e1071)

# generate data with quadratic equation
set.seed(131)
x1 <- rnorm(100)
x2 <- 3 * x1^2 + 4 + rnorm(100)

# randomly select 50 X2 observations and and shift them
# the class vector will also be used to assign classes for the outcome (y)
class <- sample(100, 50)
x2[class] <- x2[class] + 3
x2[-class] <- x2[-class] - 3

# plot using different colours
plot(x1[class], x2[class], pch=19, col="red", ylim=c(-4, 20), xlab="X1", ylab="X2")
points(x1[-class], x2[-class], pch=19, col="blue")

# create y values
set.seed(315)
y <- rep(0, 100)
y[class] <- 1

# create dataframe of x1, x2, and y
dat <- data.frame(x1 = x1, x2 = x2, y = as.factor(y))

# subset into training and testing data
train <- dat %>%
  sample_frac(0.50)
test <- setdiff(dat, train)

# create svm (linear) model
set.seed(11)
svm.linear <- svm(y ~., data = train, kernel = 'linear', cost = 10)
plot(svm.linear, train)
svm.linear.pred <- predict(svm.linear, newdata = test)
table(pred = svm.linear.pred, truth = test$y)  # 6 observations misclassified

# create svm (polynomial) model
set.seed(11)
svm.poly <- svm(y ~., data = train, kernel = 'polynomial', cost = 10)
plot(svm.poly, train)
svm.poly.pred <- predict(svm.poly, newdata = test)
table(pred = svm.poly.pred, truth = test$y)  # 14 observations misclassified

# create svm (radial model)
set.seed(11)
svm.radial <- svm(y ~., data = train, kernel = 'radial', gamma = 1, cost = 10)
plot(svm.radial, train)
svm.radial.pred <- predict(svm.radial, newdata = test)
table(pred = svm.radial.pred, truth = test$y)  # 1 observation misclassified

### Qn 5
rm(list = ls())
set.seed(421)
x1 <- runif(500) - 0.5
x2 <- runif(500) - 0.5
y = 1*(x1^2 - x2^2 > 0)
dat <- data.frame(x1 = x1, x2 = x2, y = as.factor(y))

# Qn 5.b
plot(x1, x2, col = y + 1, pch = 19)  # yes it's a non-linear decision boundary

# Qn 5.c
log.fit <- glm(y ~., data = dat, family = binomial)
summary(log.fit)

# Qn 5.d
log.prob <- predict(log.fit, newdata = dat, type = 'response')
log.pred <- ifelse(log.prob > 0.53, 1, 0)
plot(x1, x2, col = log.pred + 1, pch = 19)
# if we use log.prob > 0.5, all the observations are classified to a single class.  Thus, we've used log.prob > 0.53.  As seen in the graph, the boundary is linear

# Qn 5.e
log.fit <- glm(y ~ poly(x1, 2) + poly(x2, 2) + I(x1 * x2), data = dat, family = binomial)

# Qn 5.f
log.prob <- predict(log.fit, newdata = dat, type = 'response')
log.pred <- ifelse(log.prob > 0.5, 1, 0)
plot(x1, x2, col = log.pred + 1, pch = 19)  # the non linear decision boundary closely resembles the actual data
mean(log.pred == dat$y)

# Qn 5.g
svc.fit <- svm(y ~., data = dat, kernel = 'linear', cost = 0.001)
svc.pred <- predict(svc.fit, newdata = dat)
plot(x1, x2, col = svc.pred, pch = 19)  # with a linear kernel, even with low cost, the support vector classifier fails to identify a decision boundary and assigns all observations to a single class

# Qn 5.h
svm.fit <- svm(y ~., data = dat, kernel = 'polynomial', cost = 10)
svm.pred <- predict(svm.fit, newdata = dat)
plot(x1, x2, col = svm.pred, pch = 19)  # a polynomial kernel seems to do poorly

svm.fit <- svm(y ~., data = dat, kernel = 'radial', gamma = 1, cost = 10)
svm.pred <- predict(svm.fit, newdata = dat)
plot(x1, x2, col = svm.pred, pch = 19)  # the radial kernel closely resembles the true decision boundary

# Qn 5.i
# This experiment enforces the idea that SVMs with non-linear kernel are extremely powerful in finding non-linear boundary. Both, logistic regression with non-interactions and SVMs with linear kernels fail to find the decision boundary. Adding interaction terms to logistic regression seems to give them same power as radial-basis kernels. However, there is some manual efforts and tuning involved in picking right interaction terms. This effort can become prohibitive with large number of features. Radial basis kernels, on the other hand, only require tuning of one parameter - gamma - which can be easily done using cross-validation.

### Qn 6
set.seed(3154)
# Class one 
x1.one = runif(500, 0, 90)
x2.one = runif(500, x1.one + 10, 100)
x1.one.noise = runif(50, 20, 80)
x2.one.noise = 5 / 4 * (x1.one.noise - 10) + 0.1

# Class zero
x1.zero = runif(500, 10, 100)
x2.zero = runif(500, 0, x1.zero - 10)
x1.zero.noise = runif(50, 20, 80)
x2.zero.noise = 5 / 4 * (x1.zero.noise - 10) - 0.1

# Combine all
class.one = seq(1, 550)
x1 = c(x1.one, x1.one.noise, x1.zero, x1.zero.noise)
x2 = c(x2.one, x2.one.noise, x2.zero, x2.zero.noise)

plot(x1[class.one], x2[class.one], col="blue", pch="+", ylim=c(0, 100))
points(x1[-class.one], x2[-class.one], col="red", pch=4)

# Qn 6.b
# create y values based on class.one
set.seed(555)
y <- rep(0, 1100)
y[class.one] <- 1
dat <- data.frame(x1 = x2, x2 = x2, y = as.factor(y))
svm.tune <- tune(svm, y ~., data=dat, kernel="linear", ranges=list(cost=c(0.01, 0.1, 1, 5, 10, 100, 1000, 10000)))
summary(svm.tune)  # best parameter appears to be cost = 100
data.frame(cost = svm.tune$performances$cost, misclass = svm.tune$performances$error * 1100)

# Qn 6.c
set.seed(1111)
x1.test = runif(1000, 0, 100)
class.one = sample(1000, 500)
x2.test = rep(NA, 1000)
# Set y > x for class.one
for(i in class.one) {
  x2.test[i] <- runif(1, x1.test[i], 100)
}
# set y < x for class.zero
for (i in setdiff(1:1000, class.one)) {
  x2.test[i] <- runif(1, 0, x1.test[i])
}
plot(x1.test[class.one], x2.test[class.one], col="blue", pch="+")
points(x1.test[-class.one], x2.test[-class.one], col="red", pch=4)

set.seed(30012)
y.test <- rep(0, 1000)
y.test[class.one] <- 1
all.costs <- c(0.01, 0.1, 1, 5, 10, 100, 1000, 10000)
test.errors <- rep(NA, 8)
dat.test = data.frame(x1 = x1.test, x2 = x2.test, y = as.factor(y.test))
for (i in 1:length(all.costs)) {
  svm.fit <- svm(y~. , data = dat, kernel="linear", cost=all.costs[i])
  svm.predict <- predict(svm.fit, dat.test)
  test.errors[i] <- sum(svm.predict != dat.test$y)
}

data.frame(cost = all.costs, "test misclass" = test.errors)
# cost 5 seems to be sufficient

# Qn 7.a
rm(list = ls())
auto <- Auto
str(auto)
auto$mpglevel <- as.factor(ifelse(auto$mpg > median(auto$mpg), 1, 0))

# Qn 7.b
svc.tune <- tune(svm, mpglevel ~. -mpg, data = auto, kernel = 'linear', ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 100)))
summary(svc.tune)  # lowest cv.err is at cost = 1
# unable to plot the best model though

# Qn 7.c
svm.poly.tune <- tune(svm, mpglevel ~. -mpg, data = auto, kernel = 'polynomial', ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 100)))
summary(svm.poly.tune)  # lowest error at cost = 100, but much higher than linear

svm.radial.tune <- tune(svm, mpglevel ~. -mpg, data = auto, kernel = 'radial', ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 100, 1000), gamma = c(0.5, 1, 2, 3, 4)))
summary(svm.radial.tune)  # best param at cost = 100, gamma = 0.5.  error = 0.81, better than linear model

# Qn 7.d
svm.linear = svm(mpglevel~., data=auto, kernel="linear", cost=1)
svm.poly = svm(mpglevel~., data=auto, kernel="polynomial", cost=100, degree=2)
svm.radial = svm(mpglevel~., data=auto, kernel="radial", cost=5, gamma=0.5)

# plotpairs = function(fit){
#   for (name in names(Auto)[!(names(Auto) %in% c("mpg", "mpglevel","name"))]) {
#     plot(fit, Auto, as.formula(paste("mpg~", name, sep="")))
#   }
# }
# plotpairs(svm.linear)
# plotpairs(svm.poly)
# plotpairs(svm.radial)

plot(svm.linear, auto, mpg ~ acceleration)
plot(svm.linear, auto, mpg ~ weight)
plot(svm.linear, auto, mpg ~ horsepower)

plot(svm.radial, auto, mpg ~ acceleration)
plot(svm.radial, auto, mpg ~ weight)
plot(svm.radial, auto, mpg ~ horsepower)


# Qn 8
rm(list = ls())
oj <- OJ
str(oj)
train <- oj %>%
  sample_n(800)
test <- setdiff(oj, train)

# Qn 8.b
svc.fit <- svm(Purchase~., data = oj, kernel = 'linear', cost = 0.01)
summary(svc.fit)

# Qn 8.c
svc.train.pred <- predict(svc.fit, newdata = train)
table(pred = svc.train.pred, truth = train$Purchase)
mean(svc.train.pred == train$Purchase)  # accuracy of 0.8375 on training data

svc.test.pred <- predict(svc.fit, newdata = test)
table(pred = svc.test.pred, truth = test$Purchase)
mean(svc.test.pred == test$Purchase)  # accuracy of 0.8199 on test data

# Qn 8.d
set.seed(3)
svc.tune <- tune(svm, Purchase ~., data = train, kernel = 'linear', ranges = list(cost=10^seq(-2, 1, by=0.25)))
summary(svc.tune)  # best cost at 0.3162278

# Qn 8.e
svc.fit <- svm(Purchase ~., data = train, kernel = 'linear', cost = svc.tune$best.parameters$cost)
summary(svc.fit)

svc.train.pred <- predict(svc.fit, newdata = train)
table(pred = svc.train.pred, truth = train$Purchase)
mean(svc.train.pred == train$Purchase)  # accuracy of 0.8425 on training data

svc.test.pred <- predict(svc.fit, newdata = test)
table(pred = svc.test.pred, truth = test$Purchase)
mean(svc.test.pred == test$Purchase)  # accuracy of 0.8084 on test data

# Qn 8.f
set.seed(3)
svm.radial.tune <- tune(svm, Purchase ~., data = train, kernel = 'radial', ranges = list(cost=10^seq(-2, 1, by=0.25)))
summary(svm.radial.tune)  #best cost at 0.5623413

svm.radial.fit <- svm(Purchase ~., data = train, kernel = 'radial', cost = svm.radial.tune$best.parameters$cost)
summary(svm.radial.fit)

svm.train.pred <- predict(svm.radial.fit, newdata = train)
table(pred = svm.train.pred, truth = train$Purchase)
mean(svm.train.pred == train$Purchase)  # accuracy of 0.8525 on training data

svm.test.pred <- predict(svm.radial.fit, newdata = test)
table(pred = svm.test.pred, truth = test$Purchase)
mean(svm.test.pred == test$Purchase)  # accuracy of 0.8287 on test data

# QN 8.g
set.seed(3)
svm.poly.tune <- tune(svm, Purchase ~., data = train, kernel = 'polynomial', degree = 2, ranges = list(cost=10^seq(-2, 1, by=0.25)))
summary(svm.poly.tune)  # best cost at 10

svm.poly.fit <- svm(Purchase ~., data = train, kernel = 'polynomial', degree = 2, cost = 10)
summary(svm.poly.fit)

svm.train.pred <- predict(svm.poly.fit, newdata = train)
table(pred = svm.train.pred, truth = train$Purchase)
mean(svm.train.pred == train$Purchase)  # accuracy of 0.8475 on training data

svm.test.pred <- predict(svm.poly.fit, newdata = test)
table(pred = svm.test.pred, truth = test$Purchase)
mean(svm.test.pred == test$Purchase)  # accuracy of 0.8326 on test data

# Qn 8.h
# Overall, svm (poly) seems to have the best results on the testing data