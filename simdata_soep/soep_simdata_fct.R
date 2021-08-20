#note: if gamma distr. is wanted, the distr. parameters are still called
#mu_coef and sigma_coef in the function.
#mu_coef is then the shape parameter of the gamma distr
#sigma_coef is then the scale parameter of the gamma distr

simdata_soep_fct <- function(distr = c("normal", "gamma"), mu_coef, sigma_coef, 
                             N = 10000, cutage = c(0, seq(20, 100, by = 10)),
                             pmars, pedus, yparams, peawe, pdnat, 
                             noise = TRUE, scaling = c("norm", "stand"),
                             sim_seed = 2912){
  #seed simulation process
  set.seed(sim_seed)
  
  #some input checks
  if (length(scaling) > 1) scaling <- NULL
  
  
  #generate dataframe that will contain the simulated data
  #add intercept column
  simdat <- data.frame(X.Intercept. = rep(1, times = N))
  
  
  #####simulate age variables#######
  #first, age itself
  #(distribution roughly based on true age distr in SOEP data)
  age <- round(c(runif(N/4, 18, 40), runif(N/1.6 , 40, 78), runif(N/8, 78, 95)))
  simdat$age <- age
  #make agegroup variable 
  #(used later to later on incorporate correlation btw age and other variables)
  simdat$agegr <- as.numeric(cut(simdat$age, breaks = cutage, label = 1:(length(cutage)-1)))
  #age squared
  simdat$agesq <- (simdat$age)^2
  
  
  
  ####simulate categorical variables####
  simdat$mar1 <- 0
  simdat$mar2 <- 0
  simdat$mar3 <- 0
  simdat$mar4 <- 0
  
  #draw family status from a multinomial distribution for each age group
  for (i in 1:(length(cutage)-1)){
    pr <- pmars[i,] #get probabilities for the different family statuses from pmars matrix
    num_age <- sum(simdat$agegr == i) #how many in that age group
    mars <- t(rmultinom(n = num_age, size = 1, prob = pr))
    simdat[simdat$agegr == i, 5:8] <- mars  #5:8 are the columns in simdat df for the married variables(sorry for ugly hardcoding)
  }
  
  
  #same exact procedure for education level
  simdat$edu1d <- 0
  simdat$edu2d <- 0
  simdat$edu3d <- 0
  simdat$edu4d <- 0
  
  for (i in 1:(length(cutage)-1)){
    pr <- pedus[i,]
    num_age <- sum(simdat$agegr == i)
    edus <- t(rmultinom(n = num_age, size = 1, prob = pr))
    simdat[simdat$agegr == i, 9:12] <- edus #9:12 are columns in df for the edu variables
  }
  
  
  #####simulate income variable#####
  #again, by agegroup (from normal distribution)
  simdat$neYl <- 0
  for (i in 1:(length(cutage)-1)){
    params <- yparams[i,]
    num_age <- sum(simdat$agegr == i)
    ys <- rnorm(num_age, mean = params[1], sd = params[2])
    simdat[simdat$agegr == i, "neYl"] <- ys
  }
  
  #add additional noise
  if(noise){
    e_t <- rnorm(N)
    simdat$neYl <- simdat$neYl + e_t
  }
  
  
  ##simulate OW and DNat variables (without regard to age correlation, for now)
  simdat$OW <- 0
  OWdummy <- rbinom(N, 1, peawe)
  simdat$OW[OWdummy == 1] <- 1
  
  simdat$DNat <- 0
  DNatdummy <- rbinom(N, 1, pdnat)
  simdat$DNat[DNatdummy == 1] <- 1
  
  
  ###make dataframe into matrix to simulate health score
  simdatmat <- as.matrix(dplyr::select(simdat, names(mu_coef))) #only keep relevant variables
  #generate health score simulation values
  
  
  
  if (distr == "normal"){
    
    mu_vec <- simdatmat %*% t(as.matrix(mu_coef))
    sigma_vec <- exp(simdatmat %*% t(as.matrix(sigma_coef)))
    #simulate health score from normal distribution
    simdat$mPCS <- rnorm(N, mu_vec, sigma_vec)
    simdat$mPCS_true_mean <- mu_vec
    simdat$mPCS_true_sd <- sigma_vec
    
    #save names so they don't get thrown out in future step
    selec_vec <- c("mPCS_true_mean", "mPCS_true_sd")
    
    
  } else if (distr == "gamma") {
    #for the gamma distribution
    scale_vec <- exp(simdatmat %*% t(as.matrix(mu_coef))) 
    shape_vec <- exp(simdatmat %*% t(as.matrix(sigma_coef)))
    
    #simulate health score from gamma distribution
    simdat$mPCS <- rgamma(N, scale_vec, shape_vec)
    simdat$mPCS_true_scale <- scale_vec
    simdat$mPCS_true_shape <- shape_vec
    
    #save names so they don't get thrown out in future step
    selec_vec <- c("mPCS_true_scale", "mPCS_true_shape")
  }
  
  #only keep relevant variables for final dataset
  simdat <- dplyr::select(simdat, c(names(mu_coef), "mPCS", all_of(selec_vec)))
  simdat <- simdat[,-1] #remove intercept column 
  
  
  
  #scale numerical variables (normalization or standardization)
  if (scaling == "norm") {
    
    for (i in c(1:3)){
      meani <- mean(simdat[,i])
      maxi <- max(simdat[,i])
      mini <- min(simdat[,i])
      simdat[,i] <- (simdat[,i] - meani)/(maxi - mini)
    }
    #normalize outcome and "true" mean and std
    mean_mPCS <- mean(simdat$mPCS)
    max_mPCS <- max(simdat$mPCS)
    min_mPCS <- min(simdat$mPCS)
    range_mPCS <- max_mPCS - min_mPCS
    
    simdat$mPCS <- (simdat$mPCS - mean_mPCS) / (range_mPCS)
    simdat$mPCS_true_mean <- (simdat$mPCS_true_mean - mean_mPCS) / (range_mPCS)
    simdat$mPCS_true_sd <- simdat$mPCS_true_sd /  (range_mPCS)
    
    
  } else if (scaling == "stand") {
    
    for (i in c(1:3)){
      meani <- mean(simdat[,i])
      stdi <- sd(simdat[,i])
      simdat[,i] <- (simdat[,i] - meani)/stdi
    }
    #standardize outcome and "true" mean and std
    mean_mPCS <- mean(simdat$mPCS)
    std_mPCS <- sd(simdat$mPCS)
    
    simdat$mPCS <- (simdat$mPCS - mean_mPCS) / std_mPCS
    simdat$mPCS_true_mean <- (simdat$mPCS_true_mean - mean_mPCS) / std_mPCS
    simdat$mPCS_true_sd <- simdat$mPCS_true_sd /  std_mPCS
  }
  
  
  return(simdat)
}
