### Chapter 3 Labs

library(MASS)
#install.packages('ISLR')
library(ISLR)

names(Boston)
View(Boston)

# Linear Regression
lm.fit <- lm(medv ~ lstat, data = Boston)
lm.fit
summary(lm.fit)
names(lm.fit)

# extract coefficients
coef(lm.fit)

# extract confidence interval for coefficients
confint(lm.fit)

# predict mdev given a values of lstat
new.data <- data.frame(lstat = c(5, 10, 15))
predict(lm.fit, new.data, interval = 'confidence')  # gives an interval for the mean prediction (i.e., E[y|x]).  Thus, the interval is smaller
predict(lm.fit, new.data, interval = 'prediction')  # gives an interval for the actual prediction (i.e., y).  Thus, the intervals are wider as it takes into account the variance in y

# plot scatterplot and lm line
plot(Boston$lstat, Boston$medv)
abline(lm.fit)

# plot scatterplot and use ggplots lm
ggplot(data = Boston, aes(x = lstat, y = medv)) +
  geom_point() + 
  geom_smooth(method = 'lm')

# add predictions to dataframe and plot in ggplot
Boston$predict1 <- predict(lm.fit)
ggplot(data = Boston) +
  geom_point(aes(x = lstat, y = medv)) +
  geom_line(aes(x = lstat, y = predict1), color = 'blue')

# diagnostic plots
par(mfrow = c(2, 2))
plot(lm.fit)
par(mfrow = c(1, 1))
plot(predict(lm.fit), residuals(lm.fit))
plot(predict(lm.fit), rstudent(lm.fit))

# leverage statistics
plot(hatvalues(lm.fit))
which.max(hatvalues(lm.fit))

# Multiple Linear Regression
lm.fit <- lm(medv ~ lstat + age, data = Boston)
summary(lm.fit)

# with all 13 variables
lm.fit <- lm(medv ~ ., data = Boston)
summary(lm.fit)

?summary.lm  # to see what summary statistics are available
summary(lm.fit)$r.sq
summary(lm.fit)$sigma

# calculating VIF (variance inflation factors)
library(car)
vif(lm.fit)  # rule of thumb: VIF > 5 - 10 indicates a problem

# removing the age variable
lm.fit1 <- lm(medv ~ .-age, data = Boston)
summary(lm.fit1)

# interaction terms
lm.fitI <- lm(medv ~ lstat*age, data = Boston)
summary(lm.fit2)

# non-linear terms
lm.fit2 <- lm(medv ~ lstat + I(lstat^2), data = Boston)
summary(lm.fit3)

# use anova to compare different models
# anova performs hypothesis test between the two models
# null hypothesis: both models are as good
# alternative hypotheses: one model is better
lm.fit <- lm(medv ~ lstat, data = Boston)
anova(lm.fit, lm.fit2)
par(mfrow = c(2, 2))
plot(lm.fit2)

# fifth order polynomial fit
lm.fit5 = lm(medv ~ poly(lstat, 5), data = Boston)
summary(lm.fit5)

# Qualitative Predictors
names(Carseats)
pairs(Carseats)

lm.fit <- lm(Sales ~ . + Income:Advertising + Price:Age, data = Carseats)
summary(lm.fit)
contrasts(Carseats$ShelveLoc)

# Functions
LoadLibraries = function() {
  library(ISLR)
  library(MASS)
  print('The libraries have been loaded')
}
LoadLibraries()
