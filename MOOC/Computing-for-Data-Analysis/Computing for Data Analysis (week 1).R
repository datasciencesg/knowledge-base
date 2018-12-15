myfunction <- function () {
    x <- rnorm (100)
    mean (x)
}

second <- function(x) {
    x + rnorm (length(x))
} 

#matrix
#matrices are vectors with a dimension attribute.  the dimension attribute is itself an interger vector of length 2 (nrow, ncol)
m <- matrix (1:6, nrow = 2, ncol = 3, byrow = T)
m

m <- 1:10
m
dim(m) <- c(2,5)
m

x <- 1:3
y <- 10:12
cbind(x,y)
rbind (x,y)

#list
# lists are a special type of vector that can contain elements of different classes.  
x <- list (1, "a", TRUE, 1 + 4i)
x

#factor
#factors are used to represent categorical data.  factors can be ordered or unordered.  

x <- factor (c("yes", "yes", "no", "yes", "no"))
x
table (x)
unclass (x)

x <- factor (c("yes", "yes", "no", "yes", "no"), levels = c("yes", "no"))
x

#data frame
#data frames are used to store tabular data.  they are represented as a type of list where every column has the same length

x <- data.frame (foo = 1:4, bar = c(T, T, F, F))
x
nrow(x)
ncol(x)

#names
#R objects can also have names, which is very useful for writing readable code and self-describing objects.

x <- 1:3
names (x)
x
names (x) <- c("", "bar", "norf")
x
names(x)

#lists can also have names
x <- list (a=1, b=2, c=3)
x

#matrices too
m <- matrix (1:4, nrow = 2, ncol = 2)
dimnames(m) <- list (c("a", "b"), c("c", "d"))
m

#subsetting vectors
x <- c("a", "b", "c", "c", "d", "a")
x [1]
x [1:4]
x [x > "a"]
u <- x > "a"
u

#subsetting matrices
x <- matrix (1:6, 2, 3)
x [1,2]
x [2,1]
x [1,]
x [, 2]
#by default, when a single element of a matrix is retrieved, it is returned as a vector of length 1 rather than a 1x1 matrix
x [1,2, drop = F]
x [1, , drop = F]

#subsetting lists
x <- list (foo = 1:4, bar = 0.6)
x [1]
x [[1]]
x$bar
x[["bar"]]
x ["bar"]

x <- list (foo = 1:4, bar = 0.6, baz = "hello")
x [c(1,3)]

name <- "foo"
x [[name]]
x$name
x$foo

#[[ can take an integer sequence
x <- list (a = list (10, 12, 14), b = c(3.14, 2.81))
x [[c(1,3)]]
x [[1]] [[3]]

#partial matching
x <- list (aardvark = 1:5)
x
x$a
x [["a"]]
x [["a", exact=F]]

#removing missing values
x <- c (1, 2, NA, 4, NA, 5)
bad <- is.na(x)
x[!bad]
bad

y <- c("a", "b", NA, "d", NA, "f")

good <- complete.cases(x,y)
good
x[good]
y[good]

#vectorized operations
x <- 1:4; y <- 6:9
x + y
x * y
x / y

#vectorized matrix operations
x <- matrix (1:4, 2, 2); y <- matrix (rep(10,4), 2, 2)
x * y
x / y
x %*% y #true matrix multiplication

#reading and writing data
read.table #default seperator is " "
read.csv #default seperator is ","

colClasses #specifying this option instead of using the default can make read.table run much faster
initial <- read.table ("datatable.txt", nrows = 100)
classes <- sapply (initial, class)
table <- read.table ("datatable.txt", colClasses = classes)

#interfaces to the outside world
#dumping and dputing are useful because the resulting textual format is edit-able
#unlike writing out a table or csv, dump and dput preserve the metadata so that another user doesn't have to specify it all over again
#however, the format is not very space efficient

#dput
y <- data.frame (a=1, b="a")
y
dput(y)
dput (y, file = "y.R")
new.y <- dget ("y.R")
new.y

#dump
x <- "foo"
dump (c("x", "y"), file = "data.R")
rm (x, y)
source ("data.R")

#file: opens a connection to a file
#gzfile: opens a connection to a file compressed with gzip
#bzfile: opens a connection to a file compressed with bzip2
#url: opens a connection to a webpage

#str
#compactly display the internal structure of an R object
#a diagnostic function and an alternative to "summary"

str (str)
str (lm)

x <- rnorm (100,2,4)
x
summary (x)
str (x)

f <- gl (40,10)
str (f)
summary (f)

library (datasets)
head (airquality)
str (airquality)

m <- matrix (rnorm (100), 10, 10)
str (m)

s <- split (airquality, airquality$Month)
str (s)
describeBy (airquality, airquality$Month)