# write function to plot ROC curve
plot.roc <- function(pred, truth, ...) {
  pred.object <- prediction(pred, truth)  # creates prediction object for evaluation using ROCR
  perf <- performance(pred.object, measure = 'tpr', x.measure = 'fpr')  #  evaluates performance using tpr (true positive rate) and fpr (false positive rate)
  plot(perf, ...)
}