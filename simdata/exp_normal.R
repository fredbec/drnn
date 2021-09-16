exp_normal <- function(n, k, xrange = c(-1, 1), betas = NULL, stand = TRUE){
  #generate coefficients from uniform
  beta1 <- runif(k, 0, 1)
  beta2 <- runif(k, 0, 1)
  beta3 <- runif(k, 0, 1)
  
  runifcl <- rep(n, times = k)
  x <- sapply(runifcl, runif, xrange[1], xrange[2])
  
  #generate parameters
  mu <- x %*% beta1 + exp(x %*% beta2)
  sigma <- exp(x) %*% beta3
  
  #generate y with the specified parameters
  y <- rnorm(n, mean = mu, sd = sigma)
  
  data <- data.frame(x, y = y)
  names(data) <- c(sapply(1:k, function(k1) paste0("x", k1)), "y")
  
  if (stand){
    #unnecessary since predictors are already in same range
    #for (i in 1:k){
    #  data[,i] <- (data[,i] - min(data[,i])) / (max(data[,i]) - min(data[,i]))
    #}
    data$y <- (data$y - mean(data$y)) / (sd(data$y))
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

#expdat <- exp_sim(10000)

#plot(expdat$x, expdat$y)

#write.csv(expdat, paste0(path, "/exp2.csv"))
