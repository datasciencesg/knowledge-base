library(ISLR)
library(splines)
install.packages('gam')
library(gam)
install.packages('akima')
library(akima)
wage <- Wage

### Fitting a Polynomial function
# examine linear model fit with 4 polynomials
lm.fit <- lm(wage ~ poly(age, 4), data = wage)
summary(lm.fit)
#  note, we are not using raw = T.  Thus, poly(age, 4) will return orthogonal polynomials, where the polynomials are uncorrelated and statistically independent with each other.

lm.fit2 <- lm(wage ~ poly(age, 4, raw = T), data = wage)
summary(lm.fit2)

# similar ways of fitting this model
lm.fit2 <- lm(wage ~ age + I(age^2) + I(age^3) + I(age^4), data = wage)
summary(lm.fit2)  # same as using raw = T

lm.fit2 <- lm(wage ~ cbind(age, age^2, age^3, age^4), data = wage)
summary(lm.fit2)  # same as using raw = T

# create a grid of values for age for predictions
age.lims <- range(wage$age)
age.grid <- seq(from = age.lims[1], to = age.lims[2])

# create predictions
lm.pred <- predict(lm.fit, newdata = list(age = age.grid), se = T)
se.bands <- cbind(lm.pred$fit + 2*lm.pred$se.fit, lm.pred$fit - 2*lm.pred$se.fit)

# plot the data
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 1, 1), oma = c(0, 0, 4, 0))
plot(wage$age, wage$wage, xlim = age.lims, cex = .5, col = 'darkgrey')
title('Degree 4 Polynomial', outer = T)
lines(age.grid, lm.pred$fit, lwd = 2, col = 'blue')
matlines(age.grid, se.bands, lwd = 1, col = 'blue', lty = 2)

# create prediction with raw = T model
lm.pred2 <- predict(lm.fit2, newdata = list(age = age.grid), se = T)
max(abs(lm.pred$fit - lm.pred2$fit))  # the difference is very small and thus the fitted values are virtually identical

# create a function to create nested lm models of wage and age
lm.models <- function(degree) {
  model.list <- c()
  for (i in 1:degree) {
    lm.name <- paste("lm.fit", i, sep = "")
    lm.name <- lm(wage ~ poly(age, i), data = wage) 
    model.list <- c(model.list, lm.name)
  }
  anova(model.list)
}
lm.models(5)  # can't seem to get this to work though

lm.fit1 <- lm(wage ~ age, data = wage)
lm.fit2 <- lm(wage ~ poly(age, 2), data = wage)
lm.fit3 <- lm(wage ~ poly(age, 3), data = wage)
lm.fit4 <- lm(wage ~ poly(age, 4), data = wage)
lm.fit5 <- lm(wage ~ poly(age, 5), data = wage)
anova(lm.fit1, lm.fit2, lm.fit3, lm.fit4, lm.fit5)
# p-value of quadratic model to linear model is significant, thus linear model not sufficient
# similarly, p-value of cubic model to quadratic model is significant, thus using cubic is better than quadratic
# degree-4 and degree-5 models not significant over cubic model, thus the are not justified

summary(lm.fit5)
# the results here are similar to the anova above
# nonetheless, ANOVA works regardless of orthogonal polynomial, and also when we have other terms in the model

lm.fit1 <- lm(wage ~ education + age, data = wage)
lm.fit2 <- lm(wage ~ education + poly(age, 2), data = wage)
lm.fit3 <- lm(wage ~ education + poly(age, 3), data = wage)
anova(lm.fit1, lm.fit2, lm.fit3)

# predicting whether an individual earns more athn $250,000 a year
glm.fit <- glm(I(wage > 250) ~ poly(age, 4), data = wage, family = binomial)
glm.pred <- predict(glm.fit, newdata = list(age = age.grid), se = T)

# predictions are given in the logit form, thus we have to transform it
p.tf <- exp(glm.pred$fit)/(1 + exp(glm.pred$fit))
se.bands.logit <- cbind(glm.pred$fit + 2*glm.pred$se.fit, glm.pred$fit - 2*glm.pred$se.fit)
se.bands.tf <- exp(se.bands.logit)/(1 + exp(se.bands.logit))

# plot prediction and confidence intervals
plot(wage$age, I(wage$wage > 250), xlim = age.lims, ylim = c(0, 0.2), type = 'n')
points(jitter(wage$age), I((wage$wage >250)/5), cex = 0.5, pch = '|', col = 'darkgrey')
lines(age.grid, p.tf, lwd = 2, col = 'blue')
matlines(age.grid, se.bands.tf, lwd = 1, col = 'blue', lty = 3)

### Fitting a step function
# examine linear fit with cut() function
table(cut(wage$age, 4))
lm.fit <- lm(wage ~ cut(age, 4), data = wage)
summary(lm.fit)

### Fitting Splines
# examine cubic spline
bs.fit <- lm(wage ~ bs(age, knots = c(25, 40, 60)), data = wage)
bs.pred <- predict(spl.fit, newdata = list(age = age.grid), se = T)
plot(wage$age, wage$wage, col = 'gray')
lines(age.grid, bs.pred$fit, lwd = 2)
lines(age.grid, bs.pred$fit + 2*bs.pred$se, lty = 'dashed')
lines(age.grid, bs.pred$fit - 2*bs.pred$se, lty = 'dashed')

# using df option to choose knots at uniform quantiles of data
dim(bs(wage$age, knots = c(25, 40, 60)))
dim(bs(wage$age, df = 3))
attr(bs(wage$age, df = 6), 'knots')

# fitting a natural spline with 4 degrees of freedom
ns.fit <- lm(wage ~ ns(age, df = 4), data = wage)
ns.pred <- predict(ns.fit, newdata = list(age = age.grid), se = T)
lines(age.grid, ns.pred$fit, col = 'red', lwd = 2)

# fitting a smoothing spline
plot(wage$age, wage$wage, xlim = age.lims, cex = 0.5, col = 'darkgrey')
title('Smoothing Spline')
ss.fit <- smooth.spline(wage$age, wage$wage, df = 16)
ss.fit2 <- smooth.spline(wage$age, wage$wage, cv = T)
ss.fit2$df
lines(ss.fit, col = 'red', lwd = 2)  # df = 16
lines(ss.fit2, col = 'blue', lwd = 2)  # df = 6.8
legend('topright', legend = c('16 DF', '6.8 DF'), col = c('red', 'blue'), lty = 1, lwd = 2, cex = 0.8)

### Local Regression
plot(wage$age, wage$wage, xlim = age.lims, cex = 0.5, col = 'darkgrey')
title('Local Regression')
lr.fit <- loess(wage ~ age, span = 0.2, data = wage)
lr.fit2 <- loess(wage ~ age, span = 0.5, data = wage)
lines(age.grid, predict(lr.fit, newdata = data.frame(age = age.grid)), col = 'red', lwd = 2)
lines(age.grid, predict(lr.fit2, newdata = data.frame(age = age.grid)), col = 'blue', lwd = 2)
legend('topright', legend = c('Span = 0.2', 'Span = 0.5'), col = c('red', 'blue'), lty = 1, lwd = 2, cex = 0.8)

### Generalized Additive Models
# we can fit basic GAMs using the lm() function
gam.fit <- lm(wage ~ ns(year, df = 4) + ns(age, df = 5) + education, data = wage)

# to use smoothing splines and more general sorts of GAMs, we will need to use the gam library (gam.fit2)
gam.fit2 <- gam(wage ~ s(year, df = 4) + s(age, df = 5) + education, data = wage)
par(mfrow = c(1, 3))

# plotting GAMs
plot(gam.fit2, se = T, col = 'blue')

# we can also use plot.gam on gam.fit even though it is not of class gam 
plot.gam(gam.fit, se = T, col = 'red')

# GAM that excludes year (gam.fit3)
gam.fit3 <- gam(wage ~ s(age, df = 5) + education, data = wage)

# GAM with linear function for year (gam.fit4)
gam.fit4 <- gam(wage ~ year + s(age, df = 5) + education, data = wage)

# use anova for comparision
anova(gam.fit2, gam.fit3, gam.fit4)
# GAM with year linear function is better than no year and spline year

summary(gam.fit2)

# predictions with GAM
gam.pred <- predict(gam.fit4, newdata = wage)

# using local regression fits as building blocks in GAMs, using lo()
gam.fit5 <- gam(wage ~ s(year, df = 4) + lo(age, span = 0.7) + education, data = wage)
plot(gam.fit5, se = T, col = 'green')

# using local regression to fit interactions before calling gam
gam.fit6 <- gam(wage ~ lo(year, age, span = 0.5) + education, data = wage)

# plotting the two-dimensional surface with akima
plot(gam.fit6)

# fitting logistic regresion with GAMs
gam.fit6 <- gam(I(wage > 250) ~ year + s(age, df = 5) + education, family = binomial, data = wage)
par(mfrow = c(1, 3))
plot(gam.fit6, se = T, col = 'green')

table(wage$education, I(wage$wage > 250))

# fitting logistic GAM with all but <HS category for education
gam.fit7 <- gam(I(wage > 250) ~ year + s(age, df = 5) + education, family = binomial, data = wage, subset = (education != '1. < HS Grad'))
plot(gam.fit7, se = T, col = 'red')

