source("RCode/negloglik_new.R")
library("scoringRules")
extract_nlltable <- function(filename, k, num_files, distr = "gamma", test = TRUE){
  
  results <- data.frame(matrix(ncol = 10,
                               nrow = num_files))
  names(results) <- c("filename", "nll_ddl", "nll_gam", "nll_gamlin",# "logs_ddl", "logs_gam",
                      "crps_ddl", "crps_gam", "crps_gamlin", 
                      "mse_ddl", "mse_gam", "mse_gamlin")
  
  for (i in 1:num_files){
    dat <- read.csv(paste0(filename, k, "d_", i, ".csv"))
    if (test){
      dat <- dat[dat$testid == 1,]
    } else {
      dat <- dat[dat$testid == 0,]
    }
    
    print(nrow(dat))
    #get nll values for the two models
    if(distr == "gamma"){
      ll_ddl <- negloglik_gamma(dat$y, 
                                dat$pred_con, dat$pred_scale)
      ll_gam <- negloglik_gamma(dat$y,
                                dat$gam_shape, dat$gam_scale)
      ll_gamlin <- negloglik_gamma(dat$y,
                                    dat$gamlin_shape, dat$gamlin_scale)
      
      #logs_ddl <- mean(logs_gamma(dat$y,
      #                            dat$pred_con, scale=dat$pred_scale))
      #logs_gam <- mean(logs_gamma(dat$y,
      #                           dat$gam_shape, scale=dat$gam_scale))
      
      crps_ddl <- mean(crps_gamma(dat$y,
                                  dat$pred_con, scale=dat$pred_scale))
      crps_gam <- mean(crps_gamma(dat$y,
                                  dat$gam_shape, scale=dat$gam_scale))
      crps_gamlin <- mean(crps_gamma(dat$y,
                                  dat$gamlin_shape, scale=dat$gamlin_scale))
      
      
      #calculate means
      mean_ddl <- dat$pred_con * dat$pred_scale
      mean_gam <- dat$gam_shape * dat$gam_scale
      mean_gamlin <- dat$gamlin_shape * dat$gamlin_scale
      
      mse_ddl <- mse(dat$y, mean_ddl)
      mse_gam <- mse(dat$y, mean_gam)
      mse_gamlin <- mse(dat$y, mean_gamlin)
      
      
      
    } else if (distr == "normal"){
      ll_ddl <- negloglik_normal(dat$y, 
                                 dat$pred_mean, dat$pred_std)
      ll_gam <- negloglik_normal(dat$y,
                                 dat$gam_mean, dat$gam_scale)
      ll_gamlin <- negloglik_normal(dat$y,
                                 dat$gamlin_mean, dat$gamlin_scale)
      
      #logs_ddl <- mean(logs_norm(dat$y,
      #                      dat$pred_mean, dat$pred_std))
      #logs_gam <- mean(logs_norm(dat$y,
      #                      dat$gam_mean, dat$gam_scale))
      
      crps_ddl <- mean(crps_norm(dat$y,
                                 mean = dat$pred_mean, sd = dat$pred_std))
      crps_gam <- mean(crps_norm(dat$y,
                                 mean = dat$gam_mean, sd = dat$gam_scale))
      crps_gamlin <- mean(crps_norm(dat$y,
                                 mean = dat$gamlin_mean, sd = dat$gamlin_scale))
      
      mse_ddl <- mse(dat$y, dat$pred_mean)
      mse_gam <- mse(dat$y, dat$gam_mean)
      mse_gamlin <- mse(dat$y, dat$gamlin_mean)
      
    }
    
    results[i, "filename"] <- paste0(filename, k, "d_", i)
    results[i, "nll_ddl"] <- ll_ddl
    results[i, "nll_gam"] <- ll_gam
    results[i, "nll_gamlin"] <- ll_gamlin
    #results[i, "logs_ddl"] <- logs_ddl
    #results[i, "logs_gam"] <- logs_gam
    results[i, "crps_ddl"] <- crps_ddl
    results[i, "crps_gam"] <- crps_gam
    results[i, "crps_gamlin"] <- crps_gamlin
    results[i, "mse_ddl"] <- mse_ddl
    results[i, "mse_gam"] <- mse_gam
    results[i, "mse_gamlin"] <- mse_gamlin
  }
  return(results)
}
