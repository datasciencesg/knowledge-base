set.seed(1)
k <- 10
cv.error <- rep(NA, k)
CV <- function(k, dataset) {
  folds <- sample(rep(1:k, length = nrow(dataset)))
  progress.bar <- create_progress_bar("time")  # from plyr package
  progress.bar$init(k)
  
  for (i in 1:k) {
    train <- dataset[folds != i, ]
    test <- dataset[folds == i, ]
    my.model <- lm(crim ~ age, data = dataset)  # change the model here
    pred <- predict(my.model, newdata = test)
    cv.error[i] <<- sqrt(mean((pred - test$crim)^2))  # change the y here
    progress.bar$step()
  }
}