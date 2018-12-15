### Qn 7
library(ISLR)
set.seed(1)
dsc <- scale(USArrests)
a <- (dist(dsc))^2
b <- as.dist(1 - cor(t(dsc)))
summary(b/a)

### Qn 8.a
pr.fit <- prcomp(USArrests, scale = T)
pr.fit$sdev^2/sum(pr.fit$sdev^2)

### Qn 8.b
loadings = pr.fit$rotation
pve2 = rep(NA, 4)
dmean = apply(USArrests, 2, mean)
dsdev = sqrt(apply(USArrests, 2, var))
dsc = sweep(USArrests, MARGIN=2, dmean, "-")
dsc = sweep(dsc, MARGIN=2, dsdev, "/")
for (i in 1:4) {
  proto_x = sweep(dsc, MARGIN=2, loadings[,i], "*")
  pc_x = apply(proto_x, 1, sum)
  pve2[i] = sum(pc_x^2)
}
pve2 = pve2/sum(dsc^2)
pve2

### Qn 9.a
hc.fit.c <- hclust(dist(USArrests), method = 'complete')
plot(hc.fit.c, cex = 0.8)

# Qn 9.b
cutree(hc.fit.c, 3)
table(cutree(hc.fit.c, 3))

# Qn 9.c
scaled <- scale(USArrests)
hc.fit.c <- hclust(dist(scaled), method = 'complete')
plot(hc.fit.c)
cutree(hc.fit.c, 3)
table(cutree(hc.fit.c, 3))

# Scaling the variables effects the max height of the dendogram obtained from hierarchical clustering. From a cursory glance, it doesn't effect the bushiness of the tree obtained. However, it does affect the clusters obtained from cutting the dendogram into 3 clusters. In my opinion, for this data set the data should be standardized because the data measured has different units ($UrbanPop$ compared to other three columns).

# Qn 10.a
rm(list = ls())
set.seed(2)
x <- matrix(rnorm(20*3*50, mean=0, sd=0.001), ncol=50)
x[1:20, 2] <- 1
x[21:40, 1] <- 2
x[21:40, 2] <- 2
x[41:60, 1] <- 1

# Qn 10.b
pr.fit <- prcomp(x)
summary(pr.fit)
plot(pr.fit$x[, 1:2], col = 2:4, xlab = 'Z1', ylab = 'Z2', pch = 19)

# Qn 10.c
km.fit <- kmeans(x, 3, nstart = 20)
km.fit$cluster
table(km.fit$cluster, c(rep(1,20), rep(2,20), rep(3,20)))  # matches up perfectly

# Qn 10.d
km.fit <- kmeans(x, 2, nstart = 20)
summary(km.fit)
table(km.fit$cluster, c(rep(1,20), rep(2,20), rep(3,20)))  # clusters 1 and 3 have merged

# Qn 10.e
km.fit <- kmeans(x, 4, nstart = 20)
table(km.fit$cluster, c(rep(1,20), rep(2,20), rep(3,20)))  # cluster 1 is split into two clusters

# Qn 10.f
km.fit <- kmeans(pr.fit$x[, 1:2], 3, nstart = 20)
table(km.fit$cluster, c(rep(1,20), rep(2,20), rep(3,20)))  # the 3 clusters are still accurate

# Qn 10.g
km.fit <- kmeans(scale(x), 3, nstart = 20)
table(km.fit$cluster, c(rep(1,20), rep(2,20), rep(3,20)))
Poorer results than (b): the scaling of the observations effects the distance between them.