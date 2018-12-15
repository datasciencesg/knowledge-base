auto <- read.csv('Auto.csv', header = T, na.strings = '?')
str(auto)
auto$horsepower <- as.numeric(auto$horsepower)

# 8.a
model1 <- lm(mpg ~ horsepower, data = auto)
summary(model1)

# 8.a.iv
new.data <- data.frame(horsepower = 98)
predict(model1, new.data, interval = 'confidence')
predict(model1, new.data, interval = 'prediction')

# 8.b
plot(auto$mpg ~ auto$horsepower)
abline(model1, lwd = 3, col = 'red')

# using dplyr and ggplot
auto2 <- auto
auto2 <- auto2 %>%
  filter(horsepower > 1) %>%
  mutate(pred1 = predict(model1))

ggplot(data = auto2) +
  geom_point(aes(x = horsepower, y = mpg)) +
  geom_line(aes(x = horsepower, y = pred1), color = 'blue')

# 8.c
par(mfrow = c(2, 2))
plot(model1)

# 9.a
par(mfrow = c(1, 1))
pairs(auto)
cor(subset(auto, select=-name))

# 9.b
auto %>%
  select(-name) %>%
  cor()

# 9.c
model2 <- lm(mpg ~ . - name, data = auto)
summary(model2)

# 9.d
par(mfrow = c(2, 2))
plot(model2)
plot(predict(model2), rstudent(model2))

# 9.e
model3 <- lm(mpg ~ cylinders * displacement + displacement * weight, data = auto)
summary(model3)

# 9.f
model4 <- lm(mpg ~ log(weight) + sqrt(horsepower) + acceleration + I(acceleration^2), data = auto)
summary(model4)
plot(model4)

# 10
library(ISLR)
summary(Carseats)
seats <- Carseats
View(seats)

# 10.a
model1 <- lm(Sales ~ Price + Urban + US, data = seats)
summary(model1)

# 10.c
#Sales = 13.04 - 0.05 Price - 0.02 UrbanYes + 1.20 USYes

# 10.e
model2 <- lm(Sales ~ Price + US, data = seats)
summary(model2)  # adjusted r-sq is lower than in model 1

# 10.g
confint(model2)

# 10.h
plot(model2)

# 11
set.seed(1)
x <- rnorm(100)
y <- 2 * x + rnorm(100)

# 11.a
model1 <- lm(y ~ x + 0)  # linear regression without intercept
summary(model1)

# 11.b
model2 <- lm(x ~ y + 0)
summary(model2)

# 11.f
model3 <- lm(y ~ x)
summary(model3)
model4 <- lm(x ~ y)
summary(model4)

# 12.b
set.seed(1)
x <- rnorm(100)
y <- x
model1 <- lm(y ~ x)
summary(model1)
model2 <- lm(x ~ y)
summary(model2)

# 12.c
set.seed(1)
x <- rnorm(100)
y <- sample(x, 100)
sum(x^2)
sum(y^2)
model1 <- lm(y~x+0)
model2 <- lm(x~y+0)
summary(model1)
summary(model2)
plot(x, y)

# 13
set.seed(1)
x <- rnorm(100)
eps <- rnorm(100, mean = 0, sd = sqrt(0.25))
y <- -1 + 0.5 * x + eps

# 13.d
plot.data <- as.data.frame(cbind(x, y))
str(plot.data)
ggplot(data = plot.data, aes(x = x, y = y)) + 
  geom_point()

# 13.e 
model1 <- lm(y ~ x, data = plot.data)
summary(model1)  # linear model fits close to the true coefficients that constructed y

# 13.f
plot.data$pred <- predict(model1)
ggplot(data = plot.data, aes(x = x, y = y)) + 
  geom_point() + 
  geom_line(aes(y = pred), color = 'red') + 
  geom_abline(intercept = -1, slope = 0.5, color = 'blue')

# 13.g
model2 <- lm(y ~ x + I(x^2), data = plot.data)
summary(model2)

# 14
set.seed(1)
x1 <- runif(100)
x2 <- 0.5 * x1 + rnorm(100)/10
y <- 2 + 2*x1 + 0.3*x2 + rnorm(100)

# 14.b
plot(x1, x2)
cor(x1, x2)

# 14.c
model1 <- lm(y ~ x1 + x2)
summary(model1)

# 14.d
model2 <- lm(y ~ x1)
summary(model2)

# 14.e
model3 <- lm(y ~ x2)
summary(model3)

# 14.f
# No.  x1 and x2 have collinearity. Their effects are clearer when regressed
# seperately but are indistinguishable when regressed together

# 14.g
x1 <- c(x1, 0.1)
x2 <- c(x2, 0.8)
y <- c(y, 6)

model1 <- lm(y ~ x1 + x2)
model2 <- lm(y ~ x1)
model3 <- lm(y ~ x2)
summary(model1)
summary(model2)
summary(model3)

plot(x1, x2)
plot(x1, y)
plot(x2, y)

par(mfrow = c(2, 2))
plot(model1)
plot(model2)
plot(model3)

par(mfrow = c(1, 1))
plot(predict(model1), rstudent(model1))
plot(predict(model2), rstudent(model2))
plot(predict(model3), rstudent(model3))

# 15
str(Boston)
Boston$chas <- factor(Boston$chas, labels = c("N","Y"))

# 15.a
attach(Boston)
lm.zn <- lm(crim ~ zn)
summary(lm.zn) # yes
lm.indus <- lm(crim ~ indus)
summary(lm.indus) # yes
lm.chas <- lm(crim ~ chas) 
summary(lm.chas) # no
lm.nox <- lm(crim ~ nox)
summary(lm.nox) # yes
lm.rm <- lm(crim ~ rm)
summary(lm.rm) # yes
lm.age <- lm(crim ~ age)
summary(lm.age) # yes
lm.dis <- lm(crim ~ dis)
summary(lm.dis) # yes
lm.rad <- lm(crim ~ rad)
summary(lm.rad) # yes
lm.tax <- lm(crim ~ tax)
summary(lm.tax) # yes
lm.ptratio <- lm(crim ~ ptratio)
summary(lm.ptratio) # yes
lm.black <- lm(crim ~ black)
summary(lm.black) # yes
lm.lstat <- lm(crim ~ lstat)
summary(lm.lstat) # yes
lm.medv <- lm(crim ~ medv)
summary(lm.medv) # yes

# 15.b
model1 <- lm(crim ~ ., data = Boston)
summary(model1)

# 15.c
x = c(coefficients(lm.zn)[2],
      coefficients(lm.indus)[2],
      coefficients(lm.chas)[2],
      coefficients(lm.nox)[2],
      coefficients(lm.rm)[2],
      coefficients(lm.age)[2],
      coefficients(lm.dis)[2],
      coefficients(lm.rad)[2],
      coefficients(lm.tax)[2],
      coefficients(lm.ptratio)[2],
      coefficients(lm.black)[2],
      coefficients(lm.lstat)[2],
      coefficients(lm.medv)[2])
y = coefficients(model1)[2:14]
par(mfrow = c(1, 1))
plot(x, y)  # nox is -10 in univariate model and 31 in multivariate model
