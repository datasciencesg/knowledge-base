### Subset Selection Methods

### Best Subset Selection
library(ISLR)
library(leaps)
# install.packages('glmnet')
library(glmnet)
# install.packages('pls')
library(pls)
hit <- Hitters
str(hit)

# remove rows with missing values in any variable
sum(is.na(hit$Salary))  # 59 missing values for salary
hit <- na.omit(hit)
str(hit)

# perform best subset selection
regfit.full <- regsubsets(Salary ~., data = hit)
summary(regfit.full)

# fit a 19 variable model
regfit.full <- regsubsets(Salary ~., data = hit, nvmax = 19)
regfit.sum <- summary(regfit.full)
names(regfit.sum)

# plots of different measures
par(mfrow = c(2,2))
plot(regfit.sum$cp, type = 'b', xlab = 'No. of Variables', ylab = 'CP')
points(10, regfit.sum$cp[10], col = 'red', pch = 20)
plot(regfit.sum$bic, type = 'b', xlab = 'No. of Variables', ylab = 'BIC')
points(6, regfit.sum$bic[6], col = 'red', pch = 20)
plot(regfit.sum$rss, type = 'b', xlab = 'No. of Variables', ylab = 'RSS')
plot(regfit.sum$adjr2, type = 'b', xlab = 'No. of Variables', ylab = 'Adjusted R-squared')
points(11, regfit.sum$adjr2[11], col = 'red', pch = 20)

# find max and min values in statistics
which.min(regfit.sum$cp)
points(10, regfit.sum$cp[10], col = 'red', pch = 20)
which.min(regfit.sum$bic)
points(6, regfit.sum$bic[6], col = 'red', pch = 20)
which.max(regfit.sum$adjr2)
points(11, regfit.sum$adjr2[11], col = 'red', pch = 20)

# plotting using regsubsets' plot method
par(mfrow = c(1, 1))
?plot.regsubsets
plot(regfit.full, scale = 'r2')
plot(regfit.full, scale = 'adjr2')
plot(regfit.full, scale = 'Cp')
plot(regfit.full, scale = 'bic')

# examine coefficient estimates for different model sizes
coef(regfit.full, 5)
coef(regfit.full, 10)

# Forward Stepwise Selection
regfit.fwd <- regsubsets(Salary ~., data = hit, method = 'forward', nvmax = 19)
regfit.sum <- summary(regfit.fwd)

# Backward Stepwise Selection
regfit.bwd <- regsubsets(Salary ~., data = hit, method = 'backward', nvmax = 19)
regfit.sum <- summary(regfit.bwd)
regfit.sum

# differences in seventh variable identified
coef(regfit.full, 7)
coef(regfit.fwd, 7)
coef(regfit.bwd, 7)

### Choosing Modeling using Validation Set and Cross Validation

# Create training and testing data
set.seed(1)
train <- hit %>%
  sample_frac(0.75)

test <- setdiff(hit, train)

# best subset selection on training set
regfit.best <- regsubsets(Salary ~., data = train, nvmax = 19)
test.mtx <- model.matrix(Salary ~., data = test)  # why do we explicitly call model.matrix?

# compute test MSE for best subset models of different size
# this is a bit tedious as there is no predict() method for regsubsets
val.errors = rep(NA, 19)
for (i in 1:19) {
  coefficients <- coef(regfit.best, id = i)  # id indicates which model to return coefficient for
  pred <- test.mtx[, names(coefficients)] %*% coefficients
  val.errors[i] <- mean((test$Salary - pred) ^2)  
}
val.errors
which.min(val.errors)  # the best model is the one with 5 variables
plot(sqrt(val.errors),ylab="Root MSE",ylim=c(200,400),pch=19,type="b")
points(sqrt(regfit.best$rss[-1]/263),col="blue",pch=19,type="b")
legend("topright",legend=c("Training","Validation"),col=c("blue","black"),pch=19)

# writing our own predict() method for regsubsets
predict.regsubsets <- function(object, newdata, id, ...) {
  form <- as.formula(object$call[[2]])
  mat <- model.matrix(form, newdata)
  coefi <- coef(object, id = id)
  xvars <- names(coefi)
  mat[, xvars] %*% coefi
}

# perform best subset selection (on full data)
# note the difference: we calculate test error using only the train data but do
# best subset selection using the full data
regfit.best <- regsubsets(Salary ~., data = hit, nvmax = 19)  # using full data
coef(regfit.best, 10)

regfit.best <- regsubsets(Salary ~., data = train, nvmax = 19)  # using train data
coef(regfit.best, 10)  # notice that the features are different

### Best subset selection using cross validation

# allocate each row to one of k = 10 folds, and create matrix to store results
set.seed(1)
folds <- sample(rep(1:10, length = nrow(hit)))
table(folds)
cv.errors <- matrix(NA, nrow = 10, ncol = 19)
for (k in 1:10) {
  best.fit <- regsubsets(Salary ~., data = hit[folds != k, ], nvmax = 19)
  for (i in 1:19) {
    pred = predict(best.fit, hit[folds == k, ], id = i)
    cv.errors[k, i] = mean((hit$Salary[folds == k] - pred)^2)
  }
}

# compute root mean squared error
cv.rmse <- sqrt(apply(cv.errors, 2, mean))
plot(cv.rmse, pch = 19, type = 'b')
which.min(cv.rmse)  # an 11 variable model is chosen

# perform best subset selection on the full data set
reg.best <- regsubsets(Salary ~., data = hit, nvmax = 19)
coef(reg.best, 11)

### Ridge Regression and the Lasso
# create x (variables) and y (outcome)
x <- model.matrix(Salary ~., data = hit)[, -1]  # we remove the first column as it is the intercept field
# also, we use model.matrix as glmnet() can only take numerical, quantitative input; model.matrix will automatically transform qualitative variables into dummy variables
y <- hit$Salary

# fitting a ridge regression model (alpha = 0)
grid <- 10^seq(10, -2, length = 100)
ridge.fit <- glmnet(x, y, alpha = 0, lambda = grid )  # glmnet will automatically select a range of lambda values
plot(ridge.fit,xvar="lambda",label=TRUE)
dim(coef(ridge.fit))  # it has 20 rows (one for each predictor and an intercept) and 100 columns (one for each value of lambda)

# examining coefficient estimates
ridge.fit$lambda[50]
coef(ridge.fit)[, 50]
sqrt(sum(coef(ridge.fit)[-1, 50]^2))  # L2 norm (sum of squares of the weight) of 6.36

ridge.fit$lambda[60]
coef(ridge.fit)[, 60]
sqrt(sum(coef(ridge.fit)[-1, 60] ^2))  #L2 norm of 59.2

# use predict() to obtain ridge.regression coefficients for lambda = 50
predict(ridge.fit, s = 50, type = 'coefficients')[1:20, ]

# create training and testing data
# dplyr won't work on matrix and numeric, so it's back to basics
set.seed(1)
train <- sample(c(TRUE, TRUE, FALSE), size = nrow(hit), replace = T)  # 2/3 training data, 1/3 test data
test <- (!train)

x.train <- x[train, ]
y.train <- y[train]
x.test <- x[test, ]
y.test <- y[test]

# alternatively,
set.seed(1)
train <- sample(1:nrow(hit), nrow(hit)/2)
test <- (-train)

y.test <- y[test]

# perform ridge regression using training data and lambda = 4
ridge.fit <- glmnet(x[train, ], y[train], alpha = 0, lambda = grid, thresh = 1e-12)
ridge.pred <- predict(ridge.fit, s = 4, newx = x[test, ])
mean((ridge.pred - y.test)^2)  # MSE = 101037

# MSE from jst the intercept
mean((mean(y[train]) - y.test)^2)  # MSE = 193253

# ridge regression with lambda = 1000
ridge.pred <- predict(ridge.fit, s = 1e10, newx = x[test, ])
mean((ridge.pred - y.test)^2)  # MSE = 193253, same as if fitting on just the intercept as the coefficients are effectively 0 with such a large lambda

# ridge regression with lambda = 0, i.e., least squares
ridge.pred <- predict(ridge.fit, s = 0, newx = x[test, ], exact = T)
mean((ridge.pred - y.test)^2)  # MSE = 114783
# lm(y ~ x, subset = train)
# predict(ridge.fit, s = 0, exact = T, type = 'coefficients')[1:20, ]

# select lambda through cross validation
set.seed(1)
cv.output <- cv.glmnet(x[train, ], y[train], alpha = 0)
plot(cv.output)
best.lambda <- cv.output$lambda.min  # value of lambda with lowest cv error is 212

# what is mean MSE when labmda = 212
ridge.pred <- predict(ridge.fit, s = 212, newx = x[test, ])
mean((ridge.pred - y.test)^2)  # MSE = 96015

# refit ridge regression model on full dataset 
ridge.fit <- glmnet(x, y, alpha = 0)
predict(ridge.fit, type = 'coefficients', s = best.lambda)[1:20, ]

### The Lasso
lasso.fit <- glmnet(x[train, ], y[train], alpha = 1, lambda = grid)
plot(lasso.fit)

# perform cross validation
set.seed(1)
cv.output <- cv.glmnet(x[train, ], y[train], alpha = 1)
plot(cv.output)
best.lambda <- cv.output$lambda.min
lasso.pred <- predict(lasso.fit, s = best.lambda, newx = x[test, ])
mean((lasso.pred - y.test)^2)  # MSE = 100743

# examining coefficients from lasso 
lasso.fit <- glmnet(x, y, alpha = 1, lambda = grid)
lasso.coef <- predict(lasso.fit, type = 'coefficients', s = best.lambda)[1:20, ]
lasso.coef  # 12 of the coefficients are exactly 0, leaving only 7 variables

### Principle Components Regression (PCR)
# apply PCR predict Salary
set.seed(2)
pcr.fit <- pcr(Salary ~., data = hit, scale = T, validation = 'CV')
summary(pcr.fit)  # using only 1 component is as good as using 19 component (i.e., no dimension reduction), though it only captures 38.31% of variance

# plot cv scores
validationplot(pcr.fit, val.type = 'MSEP')

# perform PCR on training data
set.seed(1)
pcr.fit <- pcr(Salary ~., data = hit, subset = train, scale = T, validation = 'CV')
validationplot(pcr.fit, val.type = 'MSEP')
summary(pcr.fit)  # lowest CV error at 7 components

# evaluate testset MSE
pcr.pred <- predict(pcr.fit, x[test, ], ncomp = 7)
mean((pcr.pred - y.test)^2)  # MSE = 96556

# fit PCR on the full dataset
pcr.fit <- pcr(y ~ x, scale = T, ncomp = 7)
summary(pcr.fit)

### Partial Least Squares
set.seed(1)
pls.fit <- plsr(Salary ~., data = hit, subset = train, scale = T, validation = 'CV')
summary(pls.fit)
validationplot(pls.fit, val.type = 'RMSEP')

# evaluate testset MSE
pls.pred <- predict(pls.fit, x[test, ], ncomp = 2)
mean((pls.pred - y.test)^2)  # MSE = 101417

# fit PLS on full dataset
pls.fit <- plsr(Salary ~., data = hit, scale = T, ncomp = 2)
summary(pls.fit)
