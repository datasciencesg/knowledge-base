### Chapter 9 Labs

# install.packages('e1071')
library(e1071)
# install.packages('ROCR')
library(ROCR)
library(ISLR)

### Support Vector Classifier

# generate observations belowing to two classes
set.seed(10111)
x <- matrix(rnorm(20*2), ncol = 2)
y <- c(rep(-1, 10), rep(1, 10))
x[y==1, ] <- x[y==1, ] + 1

# plot observations
plot(x, col = (3 - y), pch = 19)

# create dataframe with response coded as factor

dat <- data.frame(x = x, y = as.factor(y))
svm.fit <- svm(y ~., data = dat, kernel = 'linear',  cost = 10, scale = F)
# use scale = T if you want svm() to scale each feature

# plot svm classifier
plot(svm.fit, dat)
# -1 class is light blue, +1 class is purple
# black is -1 class, red is +1 class
# support vectors are crosses while the rest are circles

# identify the support vectors
svm.fit$index

# info on support vector classifier
summary(svm.fit)

# create function to create a grid of values for x1 and x2
make.grid <- function(x, n=100){
  grange <- apply(x, 2, range)
  x1 <- seq(from = grange[1,1], to = grange[2,1], length = n)
  x2 <- seq(from = grange[1,2], to = grange[2,2], length = n)
  expand.grid(x.1 = x1, x.2 = x2)
}

# create grid for x and y
xgrid <- make.grid(x)
ygrid <- predict(svm.fit, xgrid)
plot(xgrid, col = c("red","blue")[as.numeric(ygrid)],pch = 20, cex = .2)
points(x, col = y + 3, pch = 19)
points(x[svm.fit$index,], pch = 5,cex = 2)

# extract the coefficients, and include decision boundary and two coefficients
beta <- drop(t(svm.fit$coefs)%*%x[svm.fit$index,])
beta0 <- svm.fit$rho
plot(xgrid,col = c("red","blue")[as.numeric(ygrid)],pch = 20,cex = .2)
points(x, col = y+3,pch = 19)
points(x[svm.fit$index,], pch = 5, cex = 2)
abline(beta0/beta[2], -beta[1]/beta[2])
abline((beta0-1)/beta[2], -beta[1]/beta[2], lty=2)
abline((beta0+1)/beta[2], -beta[1]/beta[2], lty=2)

# fit svm using a smaller cost parameter (c = 0.1)
svm.fit <- svm(y ~., data = dat, kernel = 'linear', cost = 0.1, scale = F)
plot(svm.fit, dat)
svm.fit$index  # smaller cost = wider margin (note: this cost =! C in equation 9.15).  Thus, as there is a wider margin, there are now a larger number of support vectors

# tuning SVC cost
set.seed(1)
svm.tune.fit <- tune(svm, y ~., data = dat, kernel = 'linear', ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 100)))
summary(svm.tune.fit)  # best model at cost = 0.1

# getting the best fit
svm.fit <- svm.tune.fit$best.model
summary(svm.fit)

# generate test data set
set.seed(1)
x.test <- matrix(rnorm(20*2), ncol = 2)
y.test <- sample(c(-1, 1), 20, rep = T)
x.test[y.test==1, ] <- x.test[y.test==1, ] + 1
dat.test <- data.frame(x = x.test, y = as.factor(y.test))

svm.pred <- predict(svm.fit, newdata = dat.test)
table(svm.pred, dat.test$y)  # 18 test observations are correctly classified

# refitting with cost = 0.01
svm.fit <- svm(y ~., data = dat, kernel = 'linear', cost = 0.01, scale = F)
svm.pred <- predict(svm.fit, newdata = dat.test)
table(svm.pred, dat.test$y)  # only 15 observations are correctly classified now

# further separate the two classes in simulated data so they are linearly separable
x[y==1, ] <- x[y==1, ] + 0.5
plot(x, col = (y+5)/2, pch = 19)  # observations are now barely linearly separable

# fit support vector classifier with large value of cost so no observations are misclassified
dat <- data.frame(x = x, y = as.factor(y))
svm.fit <- svm(y ~., data = dat, kernel = 'linear', cost = 1e5)
summary(svm.fit)
plot(svm.fit, dat)  # no training errors were made and only three support vectors used.  However, the margin is also very narrow.

# create svm.pred on test data
svm.pred <- predict(svm.fit, newdata = dat.test)
table(svm.pred, dat.test$y)  # surprisingly, manages to classify 16 cases correctly

# create model with smaller value of cost
svm.fit <- svm(y ~., data = dat, kernel = 'linear', cost = 1)
summary(svm.fit)
plot(svm.fit, dat)  # one training observation is misclassified.  However, a wider margin is also obtained and this model will likely perform better on test data

# create svm.pred on test.data
svm.pred <- predict(svm.fit, dat.test)
table(svm.pred, dat.test$y)  # 18 observations are classified correctly

### Support Vector Machine

# generate data with non-linear class boundary
set.seed(1)
x <- matrix(rnorm(200*2), ncol = 2)
x[1:100, ] <- x[1:100, ] + 2
x[101:150, ] <- x[101:150, ] - 2
y <- c(rep(1, 150), rep(2, 50))
dat <- data.frame(x = x, y = as.factor(y))
plot(x, col = y, pch = 20)  # data is non-linear

# split data into training and test set
train <- dat %>%
  sample_frac(0.67)
test <- setdiff(dat, train)

# fit svm model with radial kernel and gamma = 1
svm.fit <- svm(y ~., data = dat, kernel = 'radial', gamma = 1, cost = 1)
plot(svm.fit, train) 
# blue and purple regions denote different classes
# black and red points denote different regions
# crosses indicate support vectors while the rest are circles
summary(svm.fit)
# from the plot, there seems to be a lot of training error

# increase the cost to reduce the number of training errors (though this may be over fitting)
svm.fit <- svm(y ~., data = train, kernel = 'radial', gamma = 1, cost = 1e5)
plot(svm.fit, train)  # looks like overfitting

# cross validation using tune() to select best gamma and cost
set.seed(1)
svm.tune <- tune(svm, y ~., data = train, kernel = 'radial', ranges = list(cost = c(0.1, 1, 10, 100, 1000), gamma = c(0.5, 1, 2, 3, 4)))
summary(svm.tune)   # best params: cost = 1, gamma = 2

# derive best model
svm.fit <- svm.tune$best.model
svm.pred <- predict(svm.fit, newdata = test)
table(pred = svm.pred, true = test$y)
mean(svm.pred == test$y)  # accuracy of 0.89

### ROC (Receiver Operating Characteristic) Curve

# write function to plot ROC curve
plot.roc <- function(pred, truth, ...) {
  pred.object <- prediction(pred, truth)  # creates prediction object for evaluation using ROCR
  perf <- performance(pred.object, measure = 'tpr', x.measure = 'fpr')  #  evaluates performance using tpr (true positive rate) and fpr (false positive rate)
  plot(perf, ...)
}

# obtain fitted values from SVM using 'decision.values = T'
svm.fit <- svm(y~., data = train, kernel = 'radial', gamma = 2, cost = 1)
svm.pred <- predict(svm.fit, newdata = train, decision.values = T)
svm.fitted <- attributes(svm.pred)$decision.values

# plot ROC curve
par(mfrow = c(1, 2))
plot.roc(svm.fitted, train$y, main = 'Training Data')

# increase gamma to produce a more flexible fit and get further improvement in accuracy

svm.fit.flex <- svm(y ~., data = train, kernel = 'radial', gamma = 50, cost = 1)
svm.pred.flex <- predict(svm.fit.flex, newdata = train, decision.values = T)
svm.fitted.flex <- attributes(svm.pred.flex)$decision.values

plot.roc(svm.fitted.flex, train$y, add = T, col = 'red')

# create plots on test data
svm.pred <- predict(svm.fit, newdata = test, decision.values = T)
svm.fitted <- attributes(svm.pred)$decision.values
plot.roc(svm.fitted, test$y, main = 'Test Data')

svm.pred.flex <- predict(svm.fit.flex, newdata = test, decision.values = T)
svm.fitted.flex <- attributes(svm.pred.flex)$decision.values
plot.roc(svm.fitted.flex, test$y, add = T, col = 'red')
# while the more flexible svm performs better on the training data, it performs poorer on the test data

### SVM with multiple classes

# create data
set.seed(1)
x = rbind(x, matrix(rnorm(50*2), ncol = 2))
y = c(y, rep(0, 50))
x[y==0, 2] <- x[y==0, 2] + 2
dat <- data.frame(x = x, y = as.factor(y))
par(mfrow = c(1, 1))
plot(x, col = (y + 1), pch = 19)

# fit SVM to the data
svm.fit <- svm(y ~., data = dat, kernel = 'radial', cost = 10, gamma = 1)
plot(svm.fit, dat)

### Application to Gene Expression Data
rm(list = ls())
khan <- Khan
names(khan)
dim(khan$xtrain)
dim(khan$xtest)  # data set has very few training (63) and test (20) observations but many fields (2308)

# create svm.fit using linear kernel as there are a lot of features relative to observations
dat <- data.frame(x = khan$xtrain, y = as.factor(khan$ytrain))
svm.fit <- svm(y ~., data = dat, kernel = 'linear', cost = 10)
summary(svm.fit)
table(pred = svm.fit$fitted, truth = dat$y)  # no training errors at all

# predict on test data and assess accuracy
dat.test <- data.frame(x = khan$xtest, y = as.factor(khan$ytest))
pred.test <- predict(svm.fit, newdata = dat.test)
table(pred = pred.test, truth = dat.test$y)  # only two test set errors