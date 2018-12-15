reg.plot <- function(fit) {
  # plots cp, bic, and adjr2 from best subset models
  par(mfrow = c(1, 3))
  
  cp.min <- which.min(summary(fit)$cp)
  plot(summary(fit)$cp, type = 'b', xlab = 'No. of Variables', ylab = 'CP')
  points(cp.min, summary(fit)$cp[cp.min], col = 'red', pch = 20)
  min.cp = min(summary(fit)$cp)
  std.cp = sd(summary(fit)$cp)
  abline(h=min.cp+0.2*std.cp, col="red", lty=2)
  abline(h=min.cp-0.2*std.cp, col="red", lty=2)
  
  bic.min <- which.min(summary(fit)$bic)  # best model with 3 variables
  plot(summary(fit)$bic, type = 'b', xlab = 'No. of Variables', ylab = 'BIC')
  points(bic.min, summary(fit)$bic[bic.min], col = 'red', pch = 20)
  min.bic = min(summary(fit)$bic)
  std.bic = sd(summary(fit)$bic)
  abline(h=min.bic+0.2*std.bic, col="red", lty=2)
  abline(h=min.bic-0.2*std.bic, col="red", lty=2)
  
  adjr2.max <- which.max(summary(fit)$adjr2)  # best model with 3 variable
  plot(summary(fit)$adjr2, type = 'b', xlab = 'No. of Variables', ylab = 'Adjusted R^2')
  points(adjr2.max, summary(fit)$adjr2[adjr2.max], col = 'red', pch = 20)  
  max.adjr2 = max(summary(fit)$adjr2)
  std.adjr2 = sd(summary(fit)$adjr2)
  abline(h=max.adjr2+0.2*std.adjr2, col="red", lty=2)
  abline(h=max.adjr2-0.2*std.adjr2, col="red", lty=2)
}