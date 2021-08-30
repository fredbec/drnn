exp_gamma <- function(n, k, xrange = c(0, 1), betas = NULL, stand = TRUE){
  beta1 <- runif(k, 0, 1)
  beta2 <- runif(k, 0, 1)
  beta3 <- runif(k, 0, 1)
  
  runifcl <- rep(n, times = k)
  x <- sapply(runifcl, runif, xrange[1], xrange[2])
  
  shape <- x %*% beta1 + exp(x %*% beta2)
  scale <- exp(x) %*% beta3
  
  y <- rgamma(n, shape = shape, rate = scale)
  
  data <- data.frame(x, y = y)
  names(data) <- c(sapply(1:k, function(k1) paste0("x", k1)), "y")
  
  if (stand){
    for (i in 1:k){
      data[,i] <- (data[,i] - min(data[,i])) / (max(data[,i]) - min(data[,i]))
    }
    data$y <- (data$y - (min(data$y) - 0.01)) / (max(data$y) - min(data$y) )
  }
  
  #shuffle data just in case
  inds <- sample(nrow(data))
  data <- data[inds,]
  rownames(data) <- NULL
  
  #training/test split
  inds <- sample(nrow(data), 0.25*nrow(data))
  data$testid <- 0
  data$testid[inds] <- 1
  
  return(data)
}