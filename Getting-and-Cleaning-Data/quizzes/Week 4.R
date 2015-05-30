cam <- read.csv('cameras.csv')
View(cam)

tolower(names(cam))

str(reviews)
str(solns)
names(reviews)
gsub('_', '', names(reviews))
