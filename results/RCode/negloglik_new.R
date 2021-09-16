library("dplyr")

negloglik_gamma <- function(y, pred_shape, pred_scale){
  dens <- dgamma(y, shape = pred_shape, scale = pred_scale)
  logdens <- log(dens)
  
  res <- - sum(logdens)
  
  
  return(res/length(y))
}

negloglik_normal <- function(y, pred_loc, pred_scale){
  dens <- dnorm(y, mean = pred_loc, sd = pred_scale)
  logdens <- log(dens)
  
  res <- - sum(logdens)
  
  return(res/length(y))
}


mse <- function(y, pred_mean){
  mses <- (y - pred_mean)^2
  return(mean(mses))
}
