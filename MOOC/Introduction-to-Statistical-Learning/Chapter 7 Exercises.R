library(ISLR)
library(boot)
library(plyr)
library(gam)

# 6.a
# create CV function
set.seed(1)
k <- 10
cv.error <- rep(NA, k)
CV <- function(k, dataset) {
  folds <- sample(rep(1:k, length = nrow(dataset)))
  progress.bar <- create_progress_bar("time")  # from plyr package
  progress.bar$init(k)
  
  for (x in 1:10) {
    for (i in 1:k) {
      train <- dataset[folds != i, ]
      test <- dataset[folds == i, ]
      my.model <- lm(wage ~ poly(age, x), data = dataset)  # change the model here
      pred <- predict(my.model, newdata = test)
      cv.error[i] <<- mean((pred - test$wage)^2)  # change the y here     
      progress.bar$step()
    }
  }  
}

CV(k, Wage)
plot(cv.error, type = 'b')  # result are very unstable (to revisit when there's time)

library(ISLR)
library(boot)
cv.err = rep(NA, 10)
for (i in 1:10) {
  glm.fit <- glm(wage ~ poly(age, i), data = Wage)
  cv.err[i] = cv.glm(Wage, glm.fit, K=10)$delta[2]
}
plot(1:10, cv.err, xlab = "Degree", ylab = "CV error", type = "b", pch=20, lwd = 2, ylim = c(1590, 1700))
min.point <- min(cv.err)
sd.points <- sd(cv.err)
abline(h = min.point + 0.2 * sd.points, col="red", lty="dashed")
abline(h = min.point - 0.2 * sd.points, col="red", lty="dashed")
legend("topright", "0.2-standard deviation lines", lty="dashed", col="red")
# the plot with SD lines show that age^3 show reasonably small CV error

# finding the best degree using anova
fit.1 <- lm(wage~poly(age, 1), data=Wage)
fit.2 <- lm(wage~poly(age, 2), data=Wage)
fit.3 <- lm(wage~poly(age, 3), data=Wage)
fit.4 <- lm(wage~poly(age, 4), data=Wage)
fit.5 <- lm(wage~poly(age, 5), data=Wage)
fit.6 <- lm(wage~poly(age, 6), data=Wage)
fit.7 <- lm(wage~poly(age, 7), data=Wage)
fit.8 <- lm(wage~poly(age, 8), data=Wage)
fit.9 <- lm(wage~poly(age, 9), data=Wage)
fit.10 <- lm(wage~poly(age, 10), data=Wage)
anova(fit.1, fit.2, fit.3, fit.4, fit.5, fit.6, fit.7, fit.8, fit.9, fit.10)
# all polynomial above degree 3 are insignificant

plot(wage ~ age, data = Wage, col="darkgrey")
age.lims <- range(Wage$age)
age.grid <- seq(from=age.lims[1], to = age.lims[2])
lm.fit <- lm(wage~poly(age, 3), data = Wage)
lm.pred <- predict(lm.fit, data.frame(age=age.grid))
lines(age.grid, lm.pred, col="blue", lwd=2)

# 6.b
cv.err = rep(NA, 10)
for (i in 2:10) {
  Wage$age.cut <- cut(Wage$age, i)
  glm.fit <- glm(wage ~ age.cut, data = Wage)
  cv.err[i] <- cv.glm(Wage, glm.fit, K = 10)$delta[2]
}

plot(2:10, cv.err[-1], xlab="Number of cuts", ylab="CV error", type="l", pch=20, lwd=2)
# lowest error with cuts = 8
glm.fit <- glm(wage ~ cut(age, 8), data = Wage)

age.lims <- range(Wage$age)
age.grid <- seq(from = age.lims[1], to = age.lims[2])
glm.pred <- predict(glm.fit, newdata = data.frame(age = age.grid))

plot(wage ~ age, data = Wage, col = 'grey')
lines(age.grid, glm.pred, col = 'blue')

# 7
# exploring maritl and jobclass
summary(Wage$maritl)
summary(Wage$jobclass)
plot(Wage$wage ~ Wage$maritl)
plot(Wage$wage ~ Wage$jobclass)
# married couples seem to earn more.  Information seems to earn more than Industrial

# fitting polynomial functions
lm.fit <- lm(wage ~ maritl, data = Wage)
summary(lm.fit)
lm.fit2 <- lm(wage ~ jobclass, data = Wage)
summary(lm.fit2)
lm.fit3 <- lm(wage ~ jobclass + maritl, data = Wage)
summary(lm.fit3)

# Splines (we're unable to fit splines on categorical variables)

# GAMs
gam.fit <- gam(wage ~ maritl + jobclass + s(age, 4), data = Wage)
summary(gam.fit)
deviance(gam.fit)

# 8, examining mpg and displacement in the Auto dataset
# polynomials
fits = list()
for (d in 1:10) {
  fits[[d]] = lm(mpg~poly(displacement, d), data=Auto)
}
anova(fits[[1]], fits[[2]], fits[[3]], fits[[4]])  # it appears that a fit beyond quadratic is unnecessary

cv.err <- rep(NA, 12)
for (i in 1:12) {
  glm.fit <- glm(mpg ~ poly(displacement, i), data = Auto)
  cv.err[i] <- cv.glm(Auto, glm.fit, K = 10)$delta[2]
}
which.min(cv.err) 
plot(cv.err, type = 'b')  # looks like degree=10 has the lowest cv error

# step
cv.err <- rep(NA, 12)
for (i in 2:12) {
  Auto$dis.cut <- cut(Auto$displacement, i)
  glm.fit <- glm(mpg ~ dis.cut, data = Auto)
  cv.err[i] <- cv.glm(Auto, glm.fit, K = 10)$delta[2]
}
which.min(cv.err)
plot(cv.err, type = 'b')

# splines
cv.err <- rep(NA, 12)
for (i in 1:12) {
  ns.fit <- glm(mpg ~ ns(displacement, i), data = Auto) # natural spline)
  cv.err[i] <- cv.glm(Auto, ns.fit, K = 10)$delta[2]
}
which.min(cv.err)
plot(cv.err, type = 'b')

# find optimal no. of df via smooth.spline
ss.fit <- smooth.spline(x = Auto$displacement,  y = Auto$mpg, cv = T)
ss.fit$df  # optimal df at 20.0332

# GAM
gam.fit <- gam(mpg ~ s(displacement, 20) + s(horsepower, 20) + s(weight, 20), data = Auto)
summary(gam.fit) # weight is not significant

# 9.a
lm.fit <- lm(nox ~ poly(dis, 3), data = Boston)
summary(lm.fit)  # all polynomial terms are significant

dis.lims <- range(Boston$dis)
dis.grid <- seq(from = dis.lims[1], to = dis.lims[2], by = 0.2)
lm.pred <- predict(lm.fit, newdata = data.frame(dis = dis.grid))

plot(nox ~ dis, data = Boston, col = 'grey')
lines(dis.grid, lm.pred, col = 'blue')  # curve fits the line well

# 9.b
plot(nox ~ dis, data = Boston, col = 'grey')
rss <- rep(NA, 10)
for (i in 1:10) {
  lm.fit <- lm(nox ~ poly(dis, i), data = Boston)
  lm.pred <- predict(lm.fit, newdata = data.frame(dis = dis.grid))
  lines(dis.grid, lm.pred, col = i)
  rss[i] <- sum(lm.fit$residuals^2)
}
legend('topright', legend = c(1:10), col = c(1:10), lty = 1, lwd = 2, cex = 0.8)
which.min(rss)  # while degree = 10 has lowest rss, the fit is not smooth

# 9.c
cv.err <- rep(NA, 10)
for (i in 1:10) {
  glm.fit <- glm(nox ~ poly(dis, i), data = Boston)
  cv.err[i] <- cv.glm(data = Boston, glmfit = glm.fit, K = 10)$delta[2]
}
plot(cv.err, type = 'b')
which.min(cv.err)  # 3 is the best polynomial degree
points(3, cv.err[3], pch = 20, col = 'blue')

# using cubic splines
bs.fit <- lm(nox ~ bs(dis, df = 4), data = Boston)
summary(bs.fit)  # all df are significant
bs.pred <- predict(bs.fit, newdata = data.frame(dis = dis.grid))

plot(nox ~ dis, data = Boston, col = 'grey')
lines(dis.grid, bs.pred, lwd = 2, col = 'blue')  # spline seems to fit well except at extreme values of dis around 2 and 12

# 9.e
cv.err <- rep(NA, 16)
for (i in 3:16) {
  bs.fit <- lm(nox ~ bs(dis, df = i), data = Boston)
  cv.err[i] <- sum(bs.fit$residuals^2)
}
plot(cv.err, type = 'b')
which.min(cv.err)  # training rss is lowest at df = 14

# 9.f
cv.err <- rep(NA, 16)
for (i in 3:16) {
  bs.fit <- glm(nox ~ bs(dis, df = i), data = Boston)
  cv.err[i] <- cv.glm(Boston, bs.fit, K = 10)$delta[2]
}
plot(cv.err, type = 'b')
which.min(cv.err)  # lowest cv error at df = 6

# 10.a
?College
summary(College$Outstate)
set.seed(1)
train <- College %>%
  sample_frac(0.75)
test <- setdiff(College, train)

# fit best subsets with 17 variables max
reg.fit <- regsubsets(Outstate ~., data = College, nvmax = 17, method = 'forward')
summary(reg.fit)

reg.plot <- function(fit) {
  # plots cp, bic, and adjr2 from best subset models
  par(mfrow = c(1, 3))
  
  cp.min <- which.min(summary(fit)$cp)
  plot(summary(fit)$cp, type = 'b', xlab = 'No. of Variables', ylab = 'CP')
  points(cp.min, summary(fit)$cp[cp.min], col = 'red', pch = 20)
  min.cp = min(summary(fit)$cp)
  std.cp = sd(summary(fit)$cp)
  abline(h=min.cp+0.2*std.cp, col="red", lty=2)
  abline(h=min.cp-0.2*std.cp, col="red", lty=2)
  
  bic.min <- which.min(summary(fit)$bic)  # best model with 3 variables
  plot(summary(fit)$bic, type = 'b', xlab = 'No. of Variables', ylab = 'BIC')
  points(bic.min, summary(fit)$bic[bic.min], col = 'red', pch = 20)
  min.bic = min(summary(fit)$bic)
  std.bic = sd(summary(fit)$bic)
  abline(h=min.bic+0.2*std.bic, col="red", lty=2)
  abline(h=min.bic-0.2*std.bic, col="red", lty=2)
  
  adjr2.max <- which.max(summary(fit)$adjr2)  # best model with 3 variable
  plot(summary(fit)$adjr2, type = 'b', xlab = 'No. of Variables', ylab = 'Adjusted R^2')
  points(adjr2.max, summary(fit)$adjr2[adjr2.max], col = 'red', pch = 20)  
  max.adjr2 = max(summary(fit)$adjr2)
  std.adjr2 = sd(summary(fit)$adjr2)
  abline(h=max.adjr2+0.2*std.adjr2, col="red", lty=2)
  abline(h=max.adjr2-0.2*std.adjr2, col="red", lty=2)
}

reg.plots(reg.fit)
# the minimum subset size is between 5 and 6 for scores that are within 0.2 sd of the minimum. Thus, we use 6 as the best subset size

reg.fit <- regsubsets(Outstate ~., data = College, nvmax = 6)
summary(reg.fit)
coef(reg.fit, id = 6)

lm.fit <- lm(Outstate ~ Private + Room.Board + Terminal + perc.alumni + Expend + Grad.Rate, data = train)
lm.pred <- predict(lm.fit, newdata = test)
lm.err <- sqrt(mean((lm.pred - test$Outstate)^2))

reg.pred <- predict(reg.fit, newdata = test)

# fit GAM using Outstate and previously selected features
gam.fit <- gam(Outstate ~ Private + s(Room.Board, df = 4)+ s(Terminal, df = 4) + s(perc.alumni, df = 4) + s(Expend, df = 4) + s(Grad.Rate, df = 4), data = train)
par(mfrow = c(2, 3))
plot(gam.fit)
# in general, tuition is higher with Private colleges
# in general, tuition tends to increase with more alumni, terminal, room, and expend, and drops after 85% on grad rate

gam.pred <- predict(gam.fit, newdata = test)
gam.err <- sqrt(mean((test$Outstate - gam.pred)^2))
# gam.fit error (2077) is lower than lm.fit error (1934)

summary(gam.fit)
# moderately strong non-linear relationship for Room.Board, Expend, and Terminal, and Grad.Rate

# 11.a
set.seed(1)
x1 <- rnorm(100)
x2 <- rnorm(100)
eps = rnorm(100, sd=0.1)
Y = -2.1 + 1.3 * x1 + 0.54 * x2 + eps

# 11.b
# create a list of betas
beta0 <- rep(NA, 1000)
beta1 <- rep(NA, 1000)
beta2 <- rep(NA, 1000)
beta1[1] <- 10

# 11.c
a = Y - beta1 * x1
beta2 = lm(a ~ x2)$coef[2]

# 11.d
a = Y - beta2 * x2
beta1 = lm(a ~ x2)$coef[2]

# 11.e
for (i in 1:1000) {
  a = Y - beta1[i] * x1
  beta2[i] = lm(a ~ x2)$coef[2]
  a = Y - beta2[i] * x2
  lm.fit = lm(a ~ x1)
  if (i < 1000) {
    beta1[i+1] = lm.fit$coef[2]
  }
  beta0[i] = lm.fit$coef[1]
}
plot(1:1000, beta0, type="l", xlab="iteration", ylab="betas", ylim=c(-2.2, 1.6), col="green")
lines(1:1000, beta1, col="red")
lines(1:1000, beta2, col="blue")
legend('center', c("beta0","beta1","beta2"), lty=1, col=c("green","red","blue"))

# 11.f
lm.fit = lm(Y~X1+X2)
plot(1:1000, beta0, type="l", xlab="iteration", ylab="betas", ylim=c(-2.2, 1.6), col="green")
lines(1:1000, beta1, col="red")
lines(1:1000, beta2, col="blue")
abline(h=lm.fit$coef[1], lty="dashed", lwd=3, col=rgb(0, 0, 0, alpha=0.4))
abline(h=lm.fit$coef[2], lty="dashed", lwd=3, col=rgb(0, 0, 0, alpha=0.4))
abline(h=lm.fit$coef[3], lty="dashed", lwd=3, col=rgb(0, 0, 0, alpha=0.4))
legend('center', c("beta0","beta1","beta2", "multiple regression"), lty=c(1, 1, 1, 2), col=c("green","red","blue", "black"))

