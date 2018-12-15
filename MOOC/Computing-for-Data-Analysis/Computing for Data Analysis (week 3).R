##plotting
#base graphics
x <- rnorm (100)
hist (x)
y <- rnorm (100)
plot (x,y)
par (mar = c(2,2,2,2))
plot (x,y)
par (mar = c (4,4,2,2))

#adding lines
plot (x,y)
plot (x,y, pch = 20)
example(points)
plot (x,y, pch =20)
title ("Scatterplot")
text (-2,-2, "label")
legend ("topleft", legend = "Data")
fit <- lm (y ~ x)
abline (fit, lwd = 3, col = "blue")
plot (x,y, xlab = "Weight", ylab = "Height", main = "Scatterplot", pch = 20)
legend ("topright", legend = "Data", pch = 20)
fit <- lm (y ~ x)
abline (fit)

#points
x <- rnorm (100)
y <- x + rnorm (100)
g <- gl (2,50)
g <- gl (2, 50, labels = c("Male", "Female"))
plot (x,y, type = "n")
points (x [g == "Male"], y [g == "Male"], col = "green")
points (x [g == "Female"], y [g == "Female"], col = "blue")


#lattice graphics
x <- rnorm (100)
y <- x + rnorm (100, sd = 0.5)
f <- gl (2, 50, labels = c ("Group 1", "Group 2"))
xyplot (y ~ x | f)

data(environmental)
?environmental
head (environmental)
xyplot (ozone ~ radiation, data = environmental, main = "Ozone vs. Radiation")
xyplot (ozone ~ temperature, data = environmental)
temp.cut <- equal.count (environmental$temperature, 4)
temp.cut
xyplot (ozone ~ radiation | temp.cut, data = environmental, layout = c(1,4))
xyplot (ozone ~ radiation | temp.cut, data = environmental, layout = c(1,4), as.table = T)
xyplot (ozone ~ radiation | temp.cut, data = environmental, layout = c(1,4), as.table = T, panel = function (x, y, ...) {
    panel.xyplot (x, y, ...)
    fit <- lm (y ~ x)
    panel.abline (fit)
})
wind.cut <- equal.count (environmental$wind, 4)
xyplot (ozone ~ radiation | temp.cut * wind.cut, data = environmental, layout = c(1,4), as.table = T, panel = function (x, y, ...) {
  panel.xyplot (x, y, ...)
  fit <- lm (y ~ x)
  panel.abline (fit)
})

histogram (~ ozone | temp.cut * wind.cut, data = environmental)

##ggplot2
#package of an implementation of the Grammar of Graphics  
#automatically deals with spacings, text, titles, but also allows you to annotate by "adding"

#qplot ()
#works like plot in base graphics
#looks for data in a data frame; plots are made up of asthetics and geoms
#factors are important for indicating subsets of the data (if they are to have different properties); they should be labeled

#ggplot is the core function and very flexible for doing things qplot() cannot do
str (mpg)
qplot (displ, hwy, data = mpg)
qplot (displ, hwy, data = mpg, color = drv)

#adding a geom
qplot (displ, hwy, data = mpg, geom = c("point", "smooth"))

#histogram
qplot (hwy, data = mpg, fill = drv)

#facets
qplot (displ, hwy, data = mpg, facets = .~drv)
qplot (hwy, data = mpg, facets = drv ~ ., binwidth = 2)

#basic components of a ggplot 2
#aesthetic mappings: how data are mapped to color, size
#geoms: geometric objects like points, lines, shapes
#facets: for conditional plots
#stats: statistical transformations like binning, quantiles, smoothing
#scales: what scale an aesthetic map uses (e.g., male = red, female = blue)
#coordinate system

##simulation

#rnorm
#generate random Normal variates with a given mean and standard deviation

#dnorm
#evaluate the Normal probability density (with a given mean/SD) at a point (or vector of points)

#pnorm
#evaluate the cumulative distribution function for a Normal distribution

#rpois
#generate random Poisson variates with a given rate

#d for density
#r for random number generation
#p for cumulative distribution
#q for quantile function

x <- rnorm (10)
x
x <- rnorm (10, 20, 2)
x
summary (x)
describe (x)

set.seed (1)
rnorm (5)

rpois (10,2)
rpois (10,2)
rpois (10,20)

ppois (2, 2) ##cumulative distribution of Pr (x <= 2)
ppois (4, 2) ##cumulative distribution of Pr (x <= 2)

#generating random numbers from a linear model
set.seed (20)
x <- rnorm (100)
e <- rnorm (100, 0, 2)
y <- 0.5 + 2 * x + e
summary (y)

#when x is binary
set.seed (20)
x <- rbinom (100, 1, 0.5)
e <- rnorm (100, 0, 2)
y <- 0.5 + 2 * x + e
summary (y)
plot (x, y)

#generating random numbers from a generalized linear model
set.seed (1)
x <- rnorm (100)
log.mu <- 0.5 + 0.3 * x
y <- rpois (100, exp (log.mu))
summary (y)
plot (x, y)

#random sampling
set.seed (1)
sample (1:10, 4)
sample (1:10)
sample (1:10, replace = T)