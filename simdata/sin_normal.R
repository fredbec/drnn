sin_normal <- function(n, k, xrange = c(0, 1), betas = NULL, stand = TRUE){
  # randomly draw coefficients
  beta1 <- runif(k, 0, 1)
  beta2 <- runif(k, 0, 10)
  beta3 <- runif(k, 0, 1)

  #if (is.null(betas)){
  #  betas <- c(runif(1,-10,10), rep(1, times = k))
  #}
  
  #generate predictor matrix
  runifcl <- rep(n, times = k)
  x <- sapply(runifcl, runif, xrange[1], xrange[2])
  
  
  #generate parameters
  mu <- (x %*% beta1) * sin(x %*% beta2)
  sigma <- x %*% beta3
  #return(cbind(mu, sigma))

  #generate outcome based on the distribution parameters
  y <- rnorm(n, mu, sigma)
  #return(cbind((mu-mean(y))/sd(y), sigma/(sd(y)^2)))
  
  #put x and y in dataframe 
  data <- data.frame(x, y = y)
  names(data) <- c(sapply(1:k, function(k1) paste0("x", k1)), "y")
  
  #normalize / standardize
  if(stand) {
    #for (k in 1:ncol(x)){
    #  x[,k] <- (x[,k] - min(x[,k])) / (max(x[,k]) - min(x[,k]))
    #}
    data$y <- (y - mean(y)) / sd(y)
    
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

#set.seed(214)
#mydat <- sin_normal(10000, k = 1)
#plot(mydat$x, mydat$y)
#mydat
