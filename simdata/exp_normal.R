exp_sim <- function(n, xrange = c(-1, 1), betas = NULL, stand = TRUE){
  beta_eps <- c(5, 1.5)
  beta1 <- c(10, 3)
  beta2 <- c(1, 3)
  
  x <- runif(n, xrange[1], xrange[2])
  
  eps <- rnorm(n, 0, beta_eps[1] + beta_eps[2] * exp(-x))
  
  y <- beta1[1] + beta2[2] * x + exp(beta2[1] + beta2[2] * x) + eps
  
  if (stand){
    y <- (y - mean(y)) / sd(y)
  }
  
  expdat <- data.frame(x = x, y = y)
}

expdat <- exp_sim(10000)

plot(expdat$x, expdat$y)

write.csv(expdat, paste0(path, "/exp2.csv"))
