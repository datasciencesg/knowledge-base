### Labs
# vectors 
x <- c(1, 6, 2)
y <- c(1, 4, 3)
length(x)
length(y)
x + y
ls()
rm(x, y)
ls()

# matrices
x <- matrix(data=c(1, 2, 3, 4), nrow=2, ncol=2)
x <- matrix(data=c(1, 2, 3, 4), nrow=2, ncol=2, byrow=T)
sqrt(x)
x^2

# rnorm & cor
x <- rnorm(50)
y <- x+rnorm(50, mean=50, sd=.01)
cor(x,y)

set.seed(3)
x <- rnorm(100)
mean(x)
var(x)
sqrt(var(x))
sd(x)

# plot
x <- rnorm(100)
y <- rnorm(100) 
z <- cbind(x, y)
z <- as.data.frame(z)
z['label'] <- NA
z$label[x < 0] <- 'green'
z$label[x > 0] <- 'red'
plot(x,y)
plot(x,y, xlab='this is the x-axis', ylab='this is the y-axis', main='Plot of x vs y')

# in ggplot
ggplot(data=z, aes(x=x, y=y)) +
    geom_point(aes(color=label))

# saving figures
jpeg('ggplot')
dev.off()

# seq
x <- seq(1, 10)
x <- 1:10
x <- seq(-pi, pi, length = 50)

# contour
y <- x
f <- outer(x, y, function(x, y) cos(y) / (1 + x^2))
contour(x, y, f)
contour(x, y, f, nlevels = 45, add = T)
fa <- (f-t(f))/2
contour(x, y, fa, nlevels = 15)

# image
image(x, y, fa)
persp(x, y ,fa)
persp(x, y ,fa, theta = 30)
persp(x, y ,fa, theta = 30, phi = 20)
persp(x, y ,fa, theta = 30, phi = 70)
persp(x, y ,fa, theta = 30, phi = 400)

# indexing data
A <- matrix(1:16, nrow = 4, ncol = 4)
A[2, 3]
A[c(1,3), c(2, 4)]
A[1:3, 2:4]
A[1:2, ]
A[, 1:2]

A[-c(1,3), ]
dim(A)

# loading data
auto <- read.table('Auto.data.txt')
auto <- read.table('Auto.data.txt', header = T, na.strings = '?')
View(auto)

auto <- read.csv('Auto.csv', header = T, na.strings = '?')
View(auto)
dim(auto)

# count number of complete rows
sum(complete.cases(auto))
nrow(na.omit(auto))
names(auto)

# additional plots
plot(auto$cylinders, auto$mpg)
attach(auto)
plot(cylinders, mpg)
cylinders <- as.factor(cylinders)
plot(cylinders, mpg)
plot(cylinders, mpg, col = 'red', varwidth = T, xlab = 'cylinders', ylab = 'mpg')

# histograms
hist(mpg)
hist(mpg, col = 2)
hist(mpg, col = 2, breaks = 15)

# scatterplot matrix
pairs(auto)
pairs (~ mpg + displacement + horsepower + weight + acceleration, auto)

# identify
plot(horsepower, mpg)
identify(horsepower, mpg, name)

# summary
summary(auto)
summary(mpg)

# ggplot boxplot
plot(auto$cylinders, auto$mpg)
auto$cylinders <- as.factor(auto$cylinders)
ggplot(data=auto, aes(x=cylinders, y=mpg)) +
    geom_boxplot(aes(color=cylinder))
