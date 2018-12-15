load("5.R.RData")
str(Xy)

# create lm fit
lm.fit <- lm(y ~ X1 + X2, data = Xy)
summary(lm.fit)

# create plot
matplot(Xy,type="l")

# using bootstrap
library(boot)
boot.fn <- function(data, index) {
  return(coef(lm(y ~ X1 + X2, data = data, subset = index)))
}

boot(Xy, boot.fn, 1000)


