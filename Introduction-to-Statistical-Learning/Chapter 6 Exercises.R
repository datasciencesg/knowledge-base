library(leaps)
library(glmnet)
library(ISLR)
library(pls)
library(MASS)

# Qn 8.a
set.seed(1)
X <- rnorm(n = 100)
set.seed(1)
e <- rnorm(n = 100)

# Qn 8.b
b0 = 3
b1 = 2
b2 = -3
b3 = 0.3

Y <- b0 + b1*X + b2*(X^2) + b3*(X^3) + e

# Qn 8.c
df <- data.frame('y' = Y, 'x' = X)
reg.fit <- regsubsets(y ~ poly(x, 10, raw = T), data = df, nvmax = 10)

# create function to plot cp, bic, and adjr2 curves
reg.plots <- function(fit) {
  par(mfrow = c(2, 2))
  
  cp.min <- which.min(summary(fit)$cp)
  plot(summary(fit)$cp, type = 'b', xlab = 'No. of Variables', ylab = 'CP')
  points(cp.min, summary(fit)$cp[cp.min], col = 'red', pch = 20)
  
  bic.min <- which.min(summary(fit)$bic)  # best model with 3 variables
  plot(summary(fit)$bic, type = 'b', xlab = 'No. of Variables', ylab = 'BIC')
  points(bic.min, summary(fit)$bic[bic.min], col = 'red', pch = 20)
  
  adjr2.max <- which.max(summary(fit)$adjr2)  # best model with 3 variable
  plot(summary(fit)$adjr2, type = 'b', xlab = 'No. of Variables', ylab = 'Adjusted R^2')
  points(adjr2.max, summary(fit)$adjr2[adjr2.max], col = 'red', pch = 20)  
}

reg.plots(reg.fit)
coefficients(reg.fit, id=3)
# cp picks 8 variables as the best model.  The coefficients chosen are x, x^2, and x^3.

# Qn 8.d
reg.fwd <- regsubsets(y ~ poly(x, 10, raw = T), data = df, nvmax = 10, method = 'forward')

# plot cp, bic, adjr2 curves
reg.plots(reg.fwd)
coefficients(reg.fwd, id = 3)
# cp picks 4 variables as the best model.  Similarly, the coefficients chosen are x, x^2, and x^3.

reg.bwd <- regsubsets(y ~ poly(x, 10, raw = T), data = df, nvmax = 10, method = 'backward')

# plot cp, bic, adjr2 curves
reg.plots(reg.bwd)
coefficients(reg.bwd, id = 3)
# cp picks 8 variables as the best model.  Similarly, the coefficients chosen are x, x^2, and x^3.

# Qn 8.e
x.mat <- model.matrix(y ~ poly(x, 10, raw=T), data = df)[, -1]
lasso.fit <- cv.glmnet(x.mat, Y, alpha = 1)
best.lambda <- lasso.fit$lambda.min
par(mfrow = c(1, 1))
plot(lasso.fit)

# fit lasso.fit on entire data using best lambda
lasso.fit <- glmnet(x.mat, Y, alpha = 1)
predict(lasso.fit, type = 'coefficients', s = best.lambda)[1:11, ]
# all polynomials above 3 are excluded.

# Qn 8.f
b7 = 7
Y <- b0 + b7*(X^7) + e
df <- data.frame('y' = Y, 'x' = X)
reg.fit <- regsubsets(y ~ poly(x, 10, raw = T), data = df, nvmax = 10)
reg.plots(reg.fit)
coefficients(reg.fit, id=3)
# cp picks 9 variables as the best model, BIC picks 4, and adjr2 picks 2.  The coefficients chosen are x, x^6, and x^7.

x.mat <- model.matrix(y ~ poly(x, 10, raw=T), data = df)[, -1]
lasso.fit <- cv.glmnet(x.mat, Y, alpha = 1)
best.lambda <- lasso.fit$lambda.min
par(mfrow = c(1, 1))
plot(lasso.fit)

# fit lasso.fit on entire data using best lambda
lasso.fit <- glmnet(x.mat, Y, alpha = 1)
predict(lasso.fit, type = 'coefficients', s = best.lambda)[1:11, ]
# lasso only keeps the coefficient of x^7, but the intercept is quite off

rm(list = ls())
# Qn 9.a
?College
coll <- College
View(coll)

train <- coll %>%
  sample_frac(0.75)

test <- setdiff(coll, train)

# Qn 9.b
lm.fit <- lm(Apps ~., data = train)
lm.pred <- predict(lm.fit, newdata = test)
sqrt(mean((test$Apps - lm.pred)^2))  # RMSE = 1128

# Qn 9.c
# create model matrices for train and test data
train.mat <- model.matrix(Apps ~., data = train)[, -1]
test.mat <- model.matrix(Apps ~., data = test)[, -1]

grid <- 10^seq(10, -2, length = 100)

# create ridge regression fit
ridge.fit <- cv.glmnet(train.mat, train$Apps, alpha = 0, lambda = grid)
par(mfrow = c(1, 1))
plot(ridge.fit)
best.lambda <- ridge.fit$lambda.min
ridge.pred <- predict(ridge.fit, s = best.lambda, newx = test.mat)
sqrt(mean((ridge.pred - test$Apps)^2))  # RMSE 1127, slightly lower

# Qn 9.d
# create lasso fit
lasso.fit <- cv.glmnet(train.mat, train$Apps, alpha = 1, lambda = grid)
plot(lasso.fit)
best.lambda <- lasso.fit$lambda.min  # notice that best.lambda is not constant.  Lasso does not give a stable best lambda
lasso.pred <- predict(lasso.fit, s = best.lambda, newx = test.mat)
sqrt(mean((lasso.pred - test$Apps)^2))  # RMSE 1105
predict(lasso.fit, type = 'coefficients', s = best.lambda)[1:18, ]  # 4 variables have 0 coefficients

# Qn 9.e
set.seed(1)
pcr.fit <- pcr(Apps ~., data = train, scale = T, validation = 'CV')
validationplot(pcr.fit, val.type = 'RMSEP')
summary(pcr.fit)
pcr.pred <- predict(pcr.fit, test, ncomp = 17)
sqrt(mean((pcr.pred - test$Apps)^2))  # RMSE = 1128
?predict.mvr

# Qn 9.f
set.seed(1)
plsr.fit <- plsr(Apps ~., data = train, scale = T, validation = 'CV')
validationplot(plsr.fit, val.type = 'RMSEP')
summary(plsr.fit)  # 6 components does well enough
plsr.pred <- predict(plsr.fit, test, ncomp = 6)
sqrt(mean((plsr.pred - test$Apps)^2))  # RMSE = 1134

# Qn 9.g
# Lasso has the lowest RMSE sometimes

# Qn 10.a
set.seed(1)
p <- 20
n <- 1000
x <- matrix(rnorm(n*p), n, p)
B <- rnorm(p)
B[3] <- 0
B[4] <- 0
B[9] <- 0
B[19] <- 0
B[10] <- 0
eps <- rnorm(p)
y <- x %*% B + eps

# Qn 10.b
train <- sample(seq(1000), 100, replace = FALSE)
x.train <- x[train, ]
x.test <- x[-train, ]
y.train <- y[train]
y.test <- y[-train]
df.train <- data.frame('y' = y.train, 'x' = x.train)
df.test <- data.frame('y' = y.test, 'x' = x.test)

# Qn 10.c
reg.best <- regsubsets(y ~., data = df.train, nvmax = 20)
val.errors <- rep(NA, 20)
x.train <- as.matrix(x.train[x_cols])

# Qn 11.a
bos <- Boston
View(bos)

# Best Subset Selection

# create predict function
predict.regsubsets <- function(object, newdata, id, ...) {
  form <- as.formula(object$call[[2]])
  mat <- model.matrix(form, newdata)
  coefi <- coef(object, id = id)
  xvars <- names(coefi)
  mat[, xvars] %*% coefi
}

set.seed(1)
folds <- sample(rep(1:10, length = nrow(bos)))
table(folds)
cv.errors <- matrix(NA, nrow = 10, ncol = 13)  # create cols for each col in Boston except crim
for (k in 1:10) {
  reg.fit <- regsubsets(crim ~., data = bos[folds != k, ], nvmax = 13)
  for (i in 1:13) {
    pred = predict(reg.fit, bos[folds == k, ], id = i)
    cv.errors[k, i] = mean((bos$crim[folds == k] - pred)^2)
  }
}

reg.rmse <- sqrt(apply(cv.errors, 2, mean))
plot(reg.rmse, pch = 20, type = 'b')
min(reg.rmse)  # RMSE = 6.594
which.min(reg.rmse)
points(9, reg.rmse[9], col = 'red', pch = 20)

# Lasso
x <- model.matrix(crim ~., data = bos)[, -1]
y <- bos$crim

grid <- 10^seq(-2, 10, length = 100)
train <- sample(c(TRUE, TRUE, FALSE), size = nrow(bos), replace = T)  # 2/3 training data, 1/3 test data
test <- (!train)

lasso.fit <- cv.glmnet(x[train, ], y[train], alpha = 1)
plot(lasso.fit)
best.lambda <- lasso.fit$lambda.min  # lambda = 0.0564

lasso.pred <- predict(lasso.fit, s = best.lambda, newx = x[test, ])
sqrt(mean((lasso.pred - y[test])^2))  # RMSE = 8.983

# Ridge Regression
ridge.fit <- cv.glmnet(x[train, ], y[train], alpha = 0)
plot(ridge.fit)
best.lambda <- ridge.fit$lambda.min

ridge.pred <- predict(ridge.fit, s = best.lambda, newx = x[test, ])
sqrt(mean((ridge.pred - y[test])^2))  # RMSE = 9.00

# Principle Components Regression
pcr.fit <- pcr(crim ~., data = bos, subset = train, scale = T, validation = 'CV')
validationplot(pcr.fit)
summary(pcr.fit)

pcr.pred <- predict(pcr.fit, newdata = x[test, ], ncomps = 8)
sqrt(mean((pcr.pred - y[test])^2))  # RMSE = 9.17

# Qn 11.b
# The best subsets and lasso seem to have the lowest RMSE

# fit Lasso on full data
lasso.fit <- glmnet(x, y, alpha = 1)
lasso.coef <- predict(lasso.fit, type = 'coefficients', s = best.lambda)[1:14, ]
lasso.coef  # age and tax have coefficients of 0

# fit reg.best on full data
summary(reg.fit)
reg.plots(reg.fit)

set.seed(1)
folds <- sample(rep(1:10, length = nrow(bos)))
table(folds)
cv.errors <- matrix(NA, nrow = 10, ncol = 13)
for (k in 1:10) {
  best.fit <- regsubsets(crim ~., data = bos[folds != k, ], nvmax = 13)
  for (i in 1:13) {
    pred = predict(best.fit, bos[folds == k, ], id = i)
    cv.errors[k, i] = mean((bos$crim[folds == k] - pred)^2)
  }
}

# compute root mean squared error
cv.rmse <- sqrt(apply(cv.errors, 2, mean))
plot(cv.rmse, pch = 19, type = 'b')
which.min(cv.rmse)  # the 9 variable model has the lowest error
min(cv.rmse)

reg.fit <- regsubsets(crim ~., data = bos, nvmax = 13)
coef(reg.fit, 9)  # these are the variables for our model

# Qn 11.c
# it would not, as best subsets suggests that the 9 variable model has the lowest RMSE.  Also, it makes it easier for interpretation.
