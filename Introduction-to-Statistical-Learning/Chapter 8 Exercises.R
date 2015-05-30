### Chapter 8 Exercises
library(randomForest)
library(MASS)
library(ISLR)
library(tree)
library(gbm)
library(glmnet)

# Qn 7
bos <- Boston

# create training and test set
set.seed(1012)
train <- bos %>%
  sample_frac(0.5)
test <- setdiff(bos, train)

# separate training and test set into predictors and response
train.x <- train %>%
  select(-medv)
train.y <- train %>%
  select(medv)
train.y <- train.y[, 1]  # response variables need to be in vector format

test.x <- test %>%
  select(-medv)
test.y <- test %>%
  select(medv)
test.y <- test.y[, 1]

# create values for p
p <- dim(bos)[2] - 1
p2 <- p/2
psqrt <- sqrt(p)

# create random forest models and compute test MSE at the same time.  test MSE can be accessed as 'mse' a member of the output model
rf.fit <- randomForest(x = train.x, y = train.y, xtest = test.x, ytest = test.y, ntree = 500, mtry = p)
rf.fit2 <- randomForest(x = train.x, y = train.y, xtest = test.x, ytest = test.y, ntree = 500, mtry = p2)
rf.fit3 <- randomForest(x = train.x, y = train.y, xtest = test.x, ytest = test.y, ntree = 500, mtry = psqrt)

# plot error for trees from 1 to 500 and different p
plot(1:500, rf.fit$test$mse, type = 'l', xlab = 'No. of trees', ylab = 'MSE', col = 'red', ylim = c(9, 20))
lines(1:500, rf.fit2$test$mse, col = 'orange')
lines(1:500, rf.fit3$test$mse, col = 'green')
legend('topright', legend = c('m = p', 'm = p/2', 'm = sqrt(p)'), col = c('red', 'orange', 'green'), lty = 1)
# m = p has significantly higher error than m = p/2 or m = sqrt(p).  However, may need to try with different seeds a few times to achieve this result.

# Qn 8
rm(list = ls())
seats <- Carseats

# Qn 8.a
str(seats)
train <- seats %>%
  sample_frac(0.75)
test <- setdiff(seats, train)

# Qn 8.b
tree.fit <- tree(Sales ~., data = train)
plot(tree.fit)
text(tree.fit, pretty = 0, cex = 0.8)

# get predictions
tree.pred <- predict(tree.fit, newdata = test)
sqrt(mean((tree.pred - test$Sales)^2))  # RMSE = 2.077

# Qn 8.c
set.seed(111)
cv.fit <- cv.tree(tree.fit, FUN = prune.tree)
par(mfrow = c(1, 2))
plot(cv.fit$size, cv.fit$dev, type = 'b')
plot(cv.fit$k, cv.fit$dev, type = 'b')
cv.fit$size[which.min(cv.fit$dev)]  # best fit with 11 nodes

# create tree with node = 11
prune.fit <- prune.tree(tree.fit, best = 11)
prune.pred <- predict(prune.fit, newdata = test)
sqrt(mean((prune.pred - test$Sales)^2))  # RMSE is higher at 2.146

# Qn 8.d
bag.fit <- randomForest(Sales ~., data = train, mtry = 10, ntrees = 500, importance = T)
bag.pred <- predict(bag.fit, newdata = test)
sqrt(mean((bag.pred - test$Sales)^2))  # RMSE = 1.572
importance(bag.fit)
par(mfrow = c(1, 1))
varImpPlot(bag.fit)  # price, shelve loc, and comp price are most important

# Qn 8.e
rf.fit <- randomForest(Sales ~., data = train, mtry = 4, ntrees = 500, importance = T)
rf.pred <- predict(rf.fit, newdata = test)
sqrt(mean((rf.pred - test$Sales)^2))  # RMSE = 1.578.  In this case, randomForest worsens the test MSE
importance(rf.fit)
varImpPlot(rf.fit)

# Qn 9.a
rm(list = ls())
oj <- OJ

# create training and test set
train <- oj %>%
  sample_n(800)
test <- setdiff(oj, train)

# Qn 9.b
tree.fit <- tree(Purchase ~., data = train)
summary(tree.fit)  # misclassification error = 0.16, no. of terminal nodes = 7

# Qn 9.c
tree.fit
plot(tree.fit)
text(tree.fit, pretty = 0, cex = 0.8)

# Qn 9.d
plot(tree.fit)
text(tree.fit, pretty = 0, cex = 0.8)  # LoyalCH is the most important variable

# Qn 9.e
tree.pred <- predict(tree.fit, newdata = test, type = 'class')
table(tree.pred, test$Purchase)
mean(tree.pred == test$Purchase)  # accuracy = 0.796

# Qn 9.f
cv.fit <- cv.tree(tree.fit, FUN = prune.misclass)
cv.fit

# Qn 9.g
plot(cv.fit$size, cv.fit$dev, type = 'b')

# Qn 9.h
# tree size 5 and 7 are tied in terms of lowest cv.error

# Qn 9.i
prune.fit <- prune.tree(tree.fit, best = 5)
summary(prune.fit)  # misclassification error = 0.188, higher than tree.fit

# Qn 9.h
prune.pred <- predict(prune.fit, newdata = test, type = 'class')

mean(tree.pred == test$Purchase)  # accuracy = 0.796
mean(prune.pred == test$Purchase)  # accuracy = 0.800, higher than tree.fit

# Qn 10.a
rm(list = ls())
hit <- Hitters
hit <- hit[!is.na(hit$Salary), ]
hit$Salary <- log(hit$Salary)

# Qn 10.b, create training and test set
train = hit[1:200, ]
test <- setdiff(hit, train)

# Qn 10.c
powers <- seq(-10, -0.2, by = 0.1)
lambdas <- 10^powers
lambda.length <- length(lambdas)
train.err <- rep(NA, lambda.length)
test.err <- rep(NA, lambda.length)

for (i in 1:lambda.length) {
  gbm.fit <- gbm(Salary ~., data = train, distribution = 'gaussian', n.trees = 1000, shrinkage = lambdas[i])
  train.pred <- predict(gbm.fit, newdata = train, n.trees = 1000)
  test.pred <- predict(gbm.fit, newdata = test, n.trees = 1000)
  train.err[i] <- mean((train.pred - train$Salary)^2)
  test.err[i] <- mean((test.pred - test$Salary)^2)
}

plot(lambdas, train.err, type = 'l', col = 'red', xlab = 'Lambdas', ylab = 'MSE')
lines(lambdas, test.err, type = 'l', col = 'green')
min(test.err)  # min MSE = 0.261
lambdas[which.min(test.err)]  # min test error obtained at lamba = 0.063

# Qn 10.e
# fit linear model
lm.fit <- lm(Salary ~., data = train)
lm.pred <- predict(lm.fit, newdata = test)
mean((lm.pred - test$Salary)^2)  # MSE = 0.49

# fit lasso model
train.x <- model.matrix(Salary ~., data = train)
train.y <- train$Salary
test.x <- model.matrix(Salary ~., data = test)
lasso.fit <- glmnet(x = train.x, y = train.y, alpha = 1)
lasso.pred <- predict(lasso.fit, s = 0.01, newx = test.x)
mean((lasso.pred - test$Salary)^2)  # MSE 0.47

# Qn 10.f
summary(gbm.fit)  # CHit, PutOuts, and Walks are most important

# Qn 10.g
bag.fit <- randomForest(Salary ~., data = train, mtry = 19)
bag.pred <- predict(bag.fit, newdata = test)
mean((bag.pred - test$Salary)^2)  # MSE = 0.23, slightly lower than boost.fit MSE of 0.26

# Qn 11.a
rm(list = ls())
cara <- Caravan
cara$Purchase <- ifelse(cara$Purchase == 'Yes', 1, 0)
str(cara)
train <- cara[1:1000, ]
test <- setdiff(cara, train)

# Qn 11.b
gbm.fit <- gbm(Purchase ~., data = train, distribution = 'bernoulli', n.trees = 1000, shrinkage = 0.01)
summary(gbm.fit)  # ppersaut, mkooplka, and moplhoog are most important

# Qn 11.c
boost.prob <- predict(gbm.fit, newdata = test, type = 'response', n.trees = 1000)
boost.pred <- ifelse(boost.prob > 0.2, 1, 0)
table(boost.pred, test$Purchase)
prop.table(table(boost.pred, test$Purchase), margin = 1)  # about 20% of people predicted to make a purchase actually do

# logistic regression
log.fit <- glm(Purchase ~., data = train, family = binomial)
log.prob <- predict(log.fit, newdata = test, type = 'response')
log.pred <- ifelse(log.prob> 0.2, 1, 0)
table(lof.pred, test$Purchase)
prop.table(table(log.pred, test$Purchase), margin = 1)  # about 14.7% of people predicted to make a purchase actually do

# Qn 12 (we'll use the Weekly stock market data from ISLR)
rm(list = ls())
week <- Weekly

train <- week %>%
  sample_frac(0.75)
test <- setdiff(week, train)

# regular tree
tree.fit <- tree(Direction ~. - Year - Today, data = train)
tree.pred <- predict(tree.fit, newdata = test, type = 'class')
mean(tree.pred == test$Direction)  # accuracy = 0.559

# bagging
bag.fit <- randomForest(Direction ~. - Year - Today, data = train, mtry = 6)
bag.pred <- predict(bag.fit, newdata = test)
mean(bag.pred == test$Direction)  # accuracy = 0.538

# random forest
rf.fit <- randomForest(Direction ~. - Year - Today, data = train, mtry = 3)
rf.fit <- predict(rf.fit, newdata = test)
mean(rf.fit == test$Direction)  # accuracy = 0.584

# gbm
train$Direction <- ifelse(train$Direction == 'Up', 1, 0)
test$Direction <- ifelse(test$Direction == 'Up', 1, 0)

gbm.fit <- gbm(Direction ~. - Year - Today, data = train, distribution = 'bernoulli', n.trees = 5000, shrinkage = 0.001)
gbm.prob <- predict(gbm.fit, newdata = test, n.trees = 1000)
gbm.pred <- ifelse(gbm.prob > 0.5, 1, 0)
mean(gbm.pred == test$Direction)  # 0.452
