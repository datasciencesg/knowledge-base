### Chapter 4 Labs

rm(list=ls())
library(ISLR)

# assign Smarket and examine data
mkt <- Smarket
names(mkt)
str(mkt)
prop.table(table(mkt$Direction))

# correlation of numeric variables
mkt %>%
  select(-Direction) %>%
  cor()

# plot Volume ~ time
plot(mkt$Volume)

# add Index for plotting
for (i in 1:1250) {
  mkt$Index[i] <- i
}

# scatterplot: Volume ~ Index
ggplot(data = mkt, aes(x = Index, y = Volume)) + 
  geom_point(aes(color = factor(Year)))

# boxplot: Volume ~ Year
ggplot(data = mkt, aes(x = factor(Year), y = Volume)) + 
  geom_boxplot(aes(color = factor(Year)))

model.log <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, 
              data = mkt, family = binomial)
summary(model.log)

# to access just the coefficients
coef(model.log)

# to access just the p-value
summary(model.log)$coef[, 4]

# predict probability of market going up
pred.log <- predict(model.log, type = 'response')
contrasts(mkt$Direction)
pred.log[1:10]

pred.log.class <- ifelse(model.prob > 0.5, 'Up', 'Down')


# confusion matrix
table(pred.log.class, mkt$Direction)
prop.table(table(pred.log.class, mkt$Direction))

# create training and testing data
train <- mkt %>%
  filter(Year < 2005)

test <- mkt %>%
  filter(Year == 2005)

# create model from train data
model.log <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
                 data = train, family = binomial)

# create predictions from test
model.prob <- predict(model.log, test, type = 'response')
model.pred <- ifelse(model.prob > 0.5, 'Up', 'Down')

# assess accuracy
table(test$Direction, model.pred)
prop.table(table(test$Direction, model.pred), margin = 1)  # sensitivity = 0.31
mean(model.pred == test$Direction)  # accuracy = 0.48

# error rate
mean(model.pred != test$Direction)

# recreate model using just Lag1 and Lag2
model.log <- glm(Direction ~ Lag1 + Lag2, data = train, family = 'binomial')
summary(model.log)

# create predictions on test
model.prob <- predict(model.log, newdata = test, type = 'response')
model.pred <- ifelse(model.prob > 0.5, 'Up', 'Down')

# assess accuracy
table(test$Direction, model.pred)
prop.table(table(test$Direction, model.pred), margin = 1) # sensitivity = 0.75
mean(model.pred == test$Direction) # accuracy = 0.56

# predicting with specific values for Lag1 and Lag2
predict(model.log, newdata = data.frame(Lag1 = c(1.2, 1.5), Lag2 = c(1.1, -0.8)), type = 'response')

# fit model for LDA
lda.fit= lda(Direction ~ Lag1 + Lag2, data = train)
lda.fit

# plots of linear discriminants
plot(lda.fit)

# create predictions
lda.pred <- predict(lda.fit, newdata = test)
View(lda.pred)  # predictions are in a nested list!
lda.class <- lda.pred$class

# assess accuracy
table(lda.class, test$Direction)
prop.table(table(lda.class, test$Direction), margin = 2)
mean(lda.class == test$Direction)

# examining up and downs by posterior probability
sum(lda.pred$posterior[, 1] >= 0.5)  # we have to access the first object in the nested posterior list
sum(lda.pred$posterior[, 1] < 0.5)

# how posterior relates to class
lda.pred$posterior[1:20, 1]
lda.class[1:20]

# making predictions based on posterior probabibility at 0.51
sum(lda.pred$posterior[, 1] > 0.51)

lda.pred$adjclass <- rep('Down', 252)

# predict adjclass based on posterior > 0.51
lda.pred$adjclass[lda.pred$posterior[, 1] > 0.51] <- 'Up'
table(lda.pred$adjclass)

### quadratic discriminant analysis
qda.fit <- qda(Direction ~ Lag1 + Lag2, data = train)
qda.fit

# create predictions
qda.pred <- predict(qda.fit, newdata = test)
qda.class <- qda.pred$class

# assess accuracy
table(qda.class, test$Direction)
prop.table(table(qda.class, test$Direction))
mean(qda.class == test$Direction)

# K-Nearest Neighbours
library(class)

# create training data
mkt <- tbl_df(mkt)

# create training data
train <- mkt %>%
  filter(Year < 2005) %>%
  select(Lag1, Lag2)

# create testing data
test <- mkt %>%
  filter(Year == 2005) %>%
  select(Lag1, Lag2)

# create training classes
train.class <- mkt%>%
  filter(Year < 2005) %>%
  select(Direction)

train.class <- train.class$Direction  # training classes in KNN must be factor

# create testing classes
test.class <- mkt%>%
  filter(Year == 2005) %>%
  select(Direction)

test.class <- test.class$Direction

# create predictions with K = 1
set.seed(1)
knn.pred <- knn(train, test, train.class, k = 1)

# assess accuracy
table(knn.pred, test.class)
prop.table(table(knn.pred, test.class), margin = 2)
mean(knn.pred == test.class)

# create predictions with K = 3
set.seed(1)
knn.pred <- knn(train, test, train.class, k = 3)

# assess accuracy
table(knn.pred, test.class)
prop.table(table(knn.pred, test.class), margin = 2)
mean(knn.pred == test.class)

### applying KNN to Caravan dataset
crv <- Caravan
str(crv)

# scale variables, except Purchase variable
crv <- crv %>%
  select(-Purchase) %>%
  scale()

# create training and test set
test.rows = 1:1000

train <- crv[-test.rows, ]
test <- crv[test.rows, ]

train.class <- Caravan$Purchase[-test.rows]
test.class <- Caravan$Purchase[test.rows]

# using KNN
set.seed(1)
knn.pred <- knn(train, test, train.class, k = 1)

# assess accuracy
table(knn.pred, test.class)
prop.table(table(knn.pred, test.class), margin = 1)  # of those predicted to 
# buy insurance, 11.7% actual do, which is double of 6%
mean(knn.pred == test.class)
mean(test.class == 'No')  # if we predict all Purchase as 'No', we get 94%

# using K = 3
knn.pred <- knn(train, test, train.class, k = 3)

# assess accuracy
table(knn.pred, test.class)
prop.table(table(knn.pred, test.class), margin = 1)  

# using K = 5
knn.pred <- knn(train, test, train.class, k = 5)

# assess accuracy
table(knn.pred, test.class)
prop.table(table(knn.pred, test.class), margin = 1)  

# fitting a log regresion
train <- Caravan[-test.rows,]
test <- Caravan[test.rows, ]

glm.fit <- glm(Purchase ~ ., data = train, family = binomial)
glm.prob <- predict(glm.fit, test, type = 'response')
glm.pred <- rep('No', 1000)
glm.pred[glm.prob > 0.5] <- 'Yes'
table(glm.pred, test$Purchase)

# changing prediction to 'Purchase = Yes' when probability > 0.25
glm.pred <- rep('No', 1000)
glm.pred[glm.prob > 0.25] <- 'Yes'
table(glm.pred, test$Purchase)
prop.table(table(glm.pred, test$Purchase), margin = 1)
