sinusmd <- function(n, k = 2, xrange = c(0, 10), betas = NULL, stand = TRUE, seed = 2912){
  set.seed(seed)
  if (is.null(betas)){
    betas <- c(runif(1,-10,10), rep(1, times = k))
  }
  
  #generate predictors
  runifcl <- rep(n, times = k)
  xmat <- sapply(runifcl, runif, xrange[1], xrange[2])
  
  
  #generate error
  eps_beta <- runif(k, 0, 1)
  eps <- rnorm(n, 0, xmat %*% eps_beta)

  offset <- 3
  betas1 <- runif(k, -2, 2)
  betas2 <- runif(k, -10, 10)
  print(c(eps_beta, betas1, betas2))
  y <- offset + (xmat %*% betas1 * (1 + sin(xmat %*% betas2))) + eps
  
  
  if(stand) {
    for (k in 1:ncol(xmat)){
      xmat[,k] <- (xmat[,k] - min(xmat[,k])) / (max(xmat[,k]) - min(xmat[,k]))
    }
    y <- (y - mean(y)) / sd(y)
    
  }
  
  data <- data.frame(cbind(xmat, y))
  
  pred_names <- sapply(1:k, function(k1) paste0("x", k1))
  names(data) <- c(pred_names, 'y')
  
  return(data)
}

mydat <- sinusmd(10000, k = 1, seed = 2402)
plot(mydat$x, mydat$y)
mydat
