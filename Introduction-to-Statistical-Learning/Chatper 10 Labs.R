### Chapter 10 Labs

### PCA
View(USArrests)
states <- row.names(USArrests)

# examine mean and variance of each field
USArrests %>%
  summarise_each(funs(mean))

USArrests %>%
  summarise_each(funs(var))

# alternatively, we can use apply
sapply(USArrests, mean)
mapply(mean, USArrests)
apply(USArrests, 2, mean)

# Perform PCA using prcomp()
pr.fit <- prcomp(USArrests, scale = T)

# examine output
names(pr.fit) 
pr.fit$center  # center variable = mean of variables
pr.fit$scale  # scale variable = sd of variables

pr.fit$rotation  # rotation matrick provides the pricipal component loads

View(pr.fit$x)  # the matrix has one row for each observation, and one column for each principal component

# plotting the first two principal components
biplot(pr.fit, scale = 0, cex = 0.8)  # scale = 0 so that the arrows are scaled to represent the loadings

# reproduce figure 10.1
pr.fit$rotation <- -pr.fit$rotation
pr.fit$x <- -pr.fit$x
biplot(pr.fit, scale = 0, cex = 0.8)

# sd of each principal component
pr.fit$sdev

# variance of each principal component
pr.fit.var <- pr.fit$sdev^2

# proportion of variance explained by each principal component
# variance explained by each principal component divided by total variance explained
prop.var.ex <- pr.fit.var / sum(pr.fit.var)
prop.var.ex

# plot PVE explained by each component
par(mfrow = c(1, 2))
plot(prop.var.ex, xlab = 'Principal Component', ylab = 'Proportion of variance explained', ylim = c(0, 1), type = 'b')
plot(cumsum(prop.var.ex), xlab = 'Principal Component', ylab = 'Cumulative Proportion of Variance Explained', ylim = c(0, 1), type = 'b')

### K-means Clustering
# create simulated data
set.seed(2)
x <- matrix(rnorm(50*2), ncol = 2)
x[1:25, 1] <- x[1:25, 1] + 3
x[1:25, 2] <- x[1:25, 2] - 4

par(mfrow = c(1, 1))
plot(x, pch = 19)

# perform k-means clustering
km.fit <- kmeans(x, 2, nstart = 20)

# looks like the k-means clustering separated the observations perfectly
names(km.fit)
km.fit$cluster
plot(x, col = (km.fit$cluster + 1), main = 'K-Means Clustering, K = 2', xlab = '', ylab = '', pch = 19)

# performing km with k = 3
set.seed(4)
km.fit <- kmeans(x, centers = 3, nstart = 20)
km.fit
plot(x, col = (km.fit$cluster + 1), pch = 19)

# comparing nstart = 1 and nstart = 20
set.seed(3)
km.fit <- kmeans(x, 3, nstart = 1)
km.fit$tot.withinss  # within cluster sum of squares = 73.1

km.fit <- kmeans(x, 3, nstart = 20)
km.fit$tot.withinss  # within cluster sum of squares = 67.6
# this is the total within cluster sum of squares which we seek to minimize.  Should always run k-means with a large value of nstart (e.g. 20 - 50), or a local optimum may be obtained

### Hierarchical Clustering
hc.fit.c <- hclust(dist(x), method = 'complete')
hc.fit.a <- hclust(dist(x), method = 'average')
hc.fit.s <- hclust(dist(x), method = 'single')
# we use dist to compute the 50 x 50 inter-observation euclidean distance matrix

# plot the dendograms
par(mfrow = c(1, 3))
plot(hc.fit.c, main = 'Complete Linkage', xlab = '', sub = '', cex = 0.8)
plot(hc.fit.a, main = 'Average Linkage', xlab = '', sub = '', cex = 0.8)
plot(hc.fit.s, main = 'Single Linkage', xlab = '', sub = '', cex = 0.8)

# determine cluster labels using cutree()
cutree(hc.fit.c, 2)
cutree(hc.fit.a, 2)  
cutree(hc.fit.s, 2) # average identifies one point as belonging to its own cluster

# we can scale the variables before performing hierarcical clustering
x.sc <- scale(x)
hc.fit.c <- hclust(dist(x.sc), method = 'complete')
plot(hc.fit.c, main = 'Complete Linkage', xlab = '', sub = '', cex = 0.8)

# computing it with Correlation-based distance
# we'll need three features as the absolute correlation between any two observations with measurements on two features is always 1
x <- matrix(rnorm(30*3), ncol = 3)
dist.mat <- as.dist(1-cor(t(x)))
hc.fit.cor <- hclust(dist.mat, method = 'complete')
par(mfrow = c(1, 1))
plot(hc.fit.cor, main = 'Complete Linkage with Correlation-Based Distance', xlab = '', sub = '')

### PCA on the NC160 data
rm(list = ls())
library(ISLR)

nci.labs <- NCI60$labs
nci.data <- NCI60$data

# data has 64 rows and 6,830 columns
dim(nci.data)

# labs is a vector listing the cancer types for the 64 cell lines
table(nci.labs)

# perform PCA on nci.data
pr.fit <- prcomp(nci.data, scale = T)

# create function to assign colour to the 64 rows
Cols <- function(vector) {
  cols = rainbow(length(unique(vector)))
  return(cols[as.numeric(as.factor(vector))])
}

# plot principle component score vectors
par(mfrow = c(1, 2))
plot(pr.fit$x[, 1:2], col = Cols(nci.labs), pch = 19, xlab = 'Z1', ylab = 'Z2')
plot(pr.fit$x[, c(1, 3)], col = Cols(nci.labs), pch = 19, xlab = 'Z1', ylab = 'Z3')
# it seems that cell lines corresponding to a single cancer type have similar values on the first few principal component score vectors

# examine proportion of variance explained
summary(pr.fit)
plot(pr.fit)

# plot PVE of each principal component (i.e., scree plot)
pve <- pr.fit$sdev^2 / sum(pr.fit$sdev^2)
par(mfrow = c(1, 2))
plot(pve, type = 'o', ylab = 'PVE', xlab = 'Principal Component', col = 'blue')
plot(cumsum(pve), type = 'o', plab = 'Culmulative PVE', xlab = 'Principal Component', col = 'red')
# together, the first seven pricipal components explain about 40% of teh variance in the data

### clustering the NCI60 Data
# normalize the variables
nci.data <- scale(nci.data)

# perform hierarchical clustering
hc.fit.c <- hclust(dist(nci.data), method = 'complete')
hc.fit.a <- hclust(dist(nci.data), method = 'average')
hc.fit.s <- hclust(dist(nci.data), method = 'single')

par(mfrow = c(1, 3))
plot(hc.fit.c, labels = nci.labs, main = 'Complete Linkage', xlab = '', sub = '', ylab = '')
plot(hc.fit.a, labels = nci.labs, main = 'Average Linkage', xlab = '', sub = '', ylab = '')
plot(hc.fit.s, labels = nci.labs, main = 'Single Linkage', xlab = '', sub = '', ylab = '')
# single linkage leads to trailing clusters: large clusters where individual observations attach one-by-one.  complete and average linkage lead to more balanced clusters

# use complete linkage and cut tree to give 4 clusters
hc.clusters <- cutree(hc.fit.c, 4)
table(hc.clusters, nci.labs)  # all leukemia fall into cluster 3, and all ovarian and melanoma into cluster 1

# plot the cut on the dendogram
par(mfrow = c(1, 1))
plot(hc.fit.c, labels = nci.labs, cex = 0.8)
abline(h = 139, col = 'red')

# what if we perform k-means with k = 4
set.seed(2)
km.fit <- kmeans(nci.data, center = 4, nstart = 20)
km.clusters = km.fit$cluster
table(km.clusters, hc.clusters)  # the clusters obtained are somewhat different

# perform hierarchical clustering on the first few principal component score vectors
hc.fit.c <- hclust(dist(pr.fit$x[, 1:5]))
plot(hc.fit.c, labels = nci.labs, main = 'Hierarchical Clustering on First 5 PC Score vectors', cex = 0.8)
table(cutree(hc.fit.c, 4), nci.labs)
