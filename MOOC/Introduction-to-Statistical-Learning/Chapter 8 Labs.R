### Week 8 Labs
library(tree)
library(ISLR)
library(MASS)
library(randomForest)
library(gbm)

seats <- Carseats

# create variable High (if sales > 8, then 'Yes', else, 'No')
seats$High <- factor(ifelse(seats$Sales > 8, 'Yes', 'No'))  # need to set 'High' as factor

tree.fit <- tree(High ~. - Sales, data = seats)
summary(tree.fit)

# plotting trees
plot(tree.fit)
text(tree.fit, pretty = 0, cex = 0.7)

# printing output of the tree
tree.fit
# the output shows: no. of observations, deviance, overall prediction, fraction of No and Yes

# split into train and validation set
set.seed(2)
train <- seats %>%
  sample_frac(0.50)
test <- setdiff(seats, train)
tree.fit <- tree(High ~. -Sales, data = train)
tree.pred <- predict(tree.fit, newdata = test, type = 'class')

# assess model
table(tree.pred, test$High)
prop.table(table(tree.pred, test$High), margin = 2)

mean(tree.pred == test$High)  # accuracy = 0.715

# use cv.tree to prune tree
set.seed(4)
cvtree.fit <- cv.tree(tree.fit, FUN = prune.misclass)
cvtree.fit  # 13 node tree has the least error

# plot cv error rate as function of size and k
par(mfrow = c(1, 2))
plot(cvtree.fit$size, cvtree.fit$dev, type = 'b')  # 13 node tree has the least error
plot(cvtree.fit$k, cvtree.fit$dev, type = 'b')

# use prune.miscalss() to prune the tree to obtain the 13-node tree
prune.fit <- prune.misclass(tree.fit, best = 13)
plot(prune.fit)
text(prune.fit, pretty = 0, cex = 0.7)

# assess new pruned tree
prune.pred <- predict(prune.fit, newdata = test, type = 'class')
table(prune.pred, test$High)
mean(prune.pred == test$High)  # accuracy increases to 0.77

# increasing the value of best to get a larger prunned tree
prune.fit <- prune.misclass(tree.fit, best = 19)
prune.pred <- predict(prune.fit, newdata = test, type = 'class')
table(prune.pred, test$High)
mean(prune.pred == test$High)  # accuracy drops from 0.77 to 0.73

### Fitting Regression Trees
bos <- Boston

# create training and testing data
set.seed(1)
train <- bos %>%
  sample_frac(0.50)
test <- setdiff(bos, train)

# fit tree to predict median value of home in Boston dataset
tree.fit <- tree(medv ~. , data = bos)
summary(tree.fit)
tree.pred <- predict(tree.fit, newdata = test)

# calculate RMSE
sqrt(mean((tree.pred - test$medv)^2))  # RMSE = 3.539

# plot tree
par(mfrow = c(1, 1))
plot(tree.fit)
text(tree.fit, pretty = 0, cex = 0.7)

# use cv.tree to prune tree to improve performance
set.seed(1)
cvtree.fit <- cv.tree(tree.fit)
plot(cvtree.fit$size, cvtree.fit$dev, type = 'b')
cvtree.fit  # looks like 9 node tree is still best

# nonetheless, let's see what happens when we fit new tree with 7 nodes
prune.fit <- prune.tree(tree.fit, best = 7)
summary(prune.fit)

prune.pred <- predict(prune.fit, newdata = test)
sqrt(mean((prune.pred - test$medv)^2))  # RMSE goes up to 3.84

# examine predictions on the test set
tree.pred <- predict(tree.fit, newdata = test)
plot(tree.pred, test$medv)
abline(0,1)
mean((tree.pred - test$medv)^2)  # test set MSE = 12.52
sqrt(mean((tree.pred - test$medv)^2))  # test set RMSE = 3.53
# thus, the model leads to test predictions thare are within around #3,530 of the true median home value for the suburb

### Bagging and Random Forests
bos <- Boston

# create training and testing set
set.seed(1)
train <- bos %>%
  sample_frac(0.50)
test <- setdiff(bos, train)

# bagging (m = p, thus we use mtry = 13)
bag.fit <- randomForest(medv ~., data = train, mtry = 13, importance = T)
bag.fit

# create predictions
bag.pred <- predict(bag.fit, newdata = test)
plot(bag.pred, test$medv)
abline(0, 1)
sqrt(mean((bag.pred - test$medv)^2))  # RMSE = 3.62
mean((bag.pred - test$medv)^2)

# growing 25 trees
bag.fit <- randomForest(medv ~., data = train, mtry = 13, ntry = 25, importance = T)
bag.pred <- predict(bag.fit, newdata = test)
sqrt(mean((bag.pred - test$medv)^2))  # RMSE = 3.68

# random forest (m = sqrt(p))
set.seed(1)
rf.fit <- randomForest(medv ~., data = train, mtry = 6, importance = T)
rf.pred <- predict(rf.fit, newdata = test)
sqrt(mean((rf.pred - test$medv)^2))  # RMSE = 3.39

# view importance of randomforest fit
importance(rf.fit)
# shows increase in MSE if the variable is EXCLUDED from model
varImpPlot(rf.fit)  # lstat and rm are by far the most important variables

### Boosting
set.seed(1)
boost.fit <- gbm(medv ~., data = train, distribution = 'gaussian', n.trees = 5000, interaction.depth = 4)
summary(boost.fit)  # again, lstat and rm are the most important variables

par(mfrow = c(1, 2))
plot(boost.fit, i = 'rm')  # medv increases with rm
plot(boost.fit, i = 'lstat')  # medv decreases with lstat

boost.pred <- predict(boost.fit, newdata = test, n.trees = 5000)
sqrt(mean((boost.pred - test$medv)^2))  # RMSE = 3.44

# changing shrinkage
boost.fit <- gbm(medv ~., data = train, distribution = 'gaussian', n.trees = 5000, interaction.depth = 4, shrinkage = 0.2, verbose = F)
boost.pred <- predict(boost.fit, newdata = test, n.trees = 5000)
sqrt(mean((boost.pred - test$medv)^2))  # RMSE = 3.30
