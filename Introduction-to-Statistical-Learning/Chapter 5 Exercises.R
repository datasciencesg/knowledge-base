### Chapter 5 Exercises
library(ISLR)
rm(list = ls())

# Qn 5.a
# fit logistic model for default data set
def <- Default
str(def)
glm.fit <- glm(default ~ income + balance, data = def, family = binomial)
glm.prob <- predict(glm.fit, newdata = def)
glm.pred <- ifelse(glm.prob > 0.5, 'Yes', 'No')
table(def$default, glm.pred)
prop.table(table(def$default, glm.pred), margin = 2)

# Qn 5.b
# create training set
train <- def %>%
  sample_frac(0.75)

test <- setdiff(def, train)

# create log model
glm.fit <- glm(default ~ balance + income, data = train, family = binomial)
glm.prob <- predict(glm.fit, newdata = test, type = 'response')
glm.pred <- ifelse(glm.prob > 0.5, 'Yes', 'No')

# assess accuracy
table(test$default, glm.pred)
prop.table(table(test$default, glm.pred), margin = 2)  # sensitivity
mean(test$default == glm.pred)

# Qn 5.c
# the sensitivity varies wildly from 0.55 to 0.85 though accuracy stays around 0.97

# Qn 5.d
# create log model and include student
glm.fit <- glm(default ~ balance + income + student, data = train, family = binomial)
glm.prob <- predict(glm.fit, newdata = test, type = 'response')
glm.pred <- ifelse(glm.prob > 0.5, 'Yes', 'No')

# assess accuracy
table(test$default, glm.pred)
prop.table(table(test$default, glm.pred), margin = 2)  # sensitivity
mean(test$default == glm.pred)
# adding student doesn't seem to make a difference

# Qn 6.a
# create log model
glm.fit <- glm(default ~ balance + income, data = train, family = binomial)
summary(glm.fit)  # estimated std error about 0.5 for intercepta and at 4-6 decimal places for balance and income
summary(glm.fit)
summary(glm.fit)$coef[, 2]
coef(glm.fit)

# Qn 6.b
boot.fn <- function(data, index) {
  return (coef(glm(default ~ balance + income, data = train, family = binomial, 
              subset = index)))
}

# Qn 6.c
library(boot)
boot(def, boot.fn, 50)

# Qn 6.d
# they are very similar up to 3 significant figures

# Qn 7.a
wk <- Weekly

# create log model
glm.fit <- glm(Direction ~ Lag1 + Lag2, data = wk, family = binomial)
summary(glm.fit)

# Qn 7.b
glm.fit <- glm(Direction ~ Lag1 + Lag2, data = wk, family = binomial, subset = -1)
summary(glm.fit)

# Qn 7.c
glm.pred <- ifelse(predict(glm.fit, newdata = wk[1, ], type = 'response') > 0.5, 'Up', 'Down')
table(wk$Direction[1], glm.pred)  # wrongly classified

# Qn 7.d
accuracy <- rep(NA, dim(wk)[1])
for (i in 1:dim(wk)[1]) {
  glm.fit <- glm(Direction ~ Lag1 + Lag2, data = wk, family = binomial, subset = -i)
  glm.pred <- ifelse(predict(glm.fit, newdata = wk[i, ], type = 'response') > 0.5, 
                     'Up', 'Down')
  accuracy[i] <- as.integer(wk$Direction[i] == glm.pred)
}
sum(accuracy)  # there were 599 correct predictions

# Qn 7.e
mean(accuracy)  # mean accuracy is 0.55

# Qn 8.a
set.seed(1)
y = rnorm(100)
x = rnorm(100)
y = x - 2 * x^2 + rnorm(100)
# n = 100, p = 2, y = x - 2 * x^2 + e

# Qn 8.b
dat <- data.frame(x, y)
ggplot(data = dat, aes(x = x, y = y)) + 
  geom_point()
# y increase and then decreases as x goes from -2 to 2

# Qn 8.c
set.seed(3)
lm.fit <- glm(y ~ x, data = dat)
cv.err <- cv.glm(dat, lm.fit)$delta[1]

cv.err <- rep(NA, 4)
for (i in 1:4) {
  lm.fit <- glm(y ~ poly(x, i), data = dat)
  cv.err[i] <- cv.glm(dat, lm.fit)$delta[1]
}
plot(cv.err, type = 'b')

# Qn 8.d
# the results are exactly the same as LOOCV calculates n-folds of a single observation

# Qn 8.e
# the quadratic model had the smallest LOOCV error, as suggested by the scatterplot

# Qn 8.f
summary(lm.fit)
# only the linear and quadratic terms are significant.  This is aligned with the LOOCV results

# Qn 9.a
library(MASS)
bos <- Boston
mean(bos$medv)  # mean = 22.53

# Qn 9.b
sd(bos$medv) / sqrt(length(bos$medv))  # std err = 0.4089

# Qn 9.c
boot.fn <- function(data, index) {
  mean(data[index])
}
boot.stp <- boot(bos$medv, boot.fn, 100)  # the std err is similar up to 2 sig fig

# Qn 9.d
# compute 95% confint
c(boot.stp$t0 - 2*0.4256, boot.stp$t0 + 2*0.4256)
t.test(bos$medv)
# bootstrap sample is very close to t.test results

# Qn 9.e
median(bos$medv)

# Qn 9.f
boot.fn <- function(data, index) {
  median(data[index])
}
boot(bos$medv, boot.fn, 100)  # std err = 0.3768
# the std error is small compared to the median value

# Qn 9.g
quantile(bos$medv, c(0.1))

# Qn 9.h
boot.fn <- function(data, index) {
  return(quantile(data[index], c(0.1)))
}
boot(bos$medv, boot.fn, 100)  # quantile is 12.75 (same as actual) with std err at 0.60 (small compared to median value)