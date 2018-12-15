#control structures in R
 
#if, else: testing a condition
if (<condition>) {
      ## do something
} else {
      ## do something else
}

if (<condition>) {
      ## do something
} else if (<condition2>) {
      ## do something different
} else {
      ## do something different
}

#for: execute a loop a fixed number of times
#for loops take a iterator variable and assign it successive values from a sequence or vector

for (i in 1:10) {
    print (i)
}

x <- c ("a", "b", "c", "d")

for (i in 1:4) {
    print (x[i])
}

for(letter in x) {
    print (letter)
}

#nested for loops

x <- matrix (1:6, 2, 3)

for (i in seq_len (nrow(x))) {
    for (j in seq_len (ncol(x))) {
        print (x[i,j])
    }
}

#while: execute a loop while a condition is true
#while loops begin by testing a condition. if it is true, then they execute the loop body.  once the loop body is executed, the condition is tested again, and so forth

count <- 0

while (count < 10) {
    print (count)
    count <- count + 1
}

#repeat: execute an infinite loop
#initiates an infinite loop; these are not commonly used in statistical application but they do have their uses; the only way to exit a repeat loop is to call break.

#break: break the execution of a loop

#next: skip an iteration of a loop
for (i in 1:100) {
    if (i <= 20) {
      ## skip the first 20 iterations
      next
    }
    ## do something here
    print (i)
}

#return: exit a function
#signals that a function should exit and return a given value

##functions
#created using the function () directive and are stored as R objects just like anything eles.

f <- function (<arguments>) {
    #do something interesting
}

mydata <- rnorm (100)
sd (mydata)
args (lm) 

#...
#indicates a variable number of arguments that are usually passed on to other functions
#when the number of arguments passed to the function cannot be known in advance

#mapply
#multivariate apply of sorts which applies a function in parallel over a set of arguments
list (rep (1,4) ,rep (2,3), rep (3,2), rep (4,1))
mapply (rep, 1:4, 4:1)

#tapply
#used to apply a function over subsets of a vector
x <- c(rnorm (10), runif(10), rnorm (10,1))
f <- gl (3,10)
tapply (x, f, mean)
tapply (x, f, mean, simplify = F)
tapply (x, f, range, simplify = F)

#split
#takes a vector or other objects and splits it into groups determined by a factor or list of factors
split (x, f)

#common to split followed by lapply
lapply (split (x,f), mean)

library (datasets)
head (airquality)
library (psych)
describeBy (airquality, airquality$Month, digits=30)
#or
s <- split (airquality, airquality$Month)
lapply (s, function (x) colMeans (x [,c("Ozone", "Solar.R", "Wind")]))

sapply (s, function (x) colMeans (x [,c("Ozone", "Solar.R", "Wind")], na.rm = TRUE))