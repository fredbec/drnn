rm(list = ls())

setwd("C:/Users/rike/Nextcloud/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/results")
source("RCode/extract_nll_withlin.R")
source("RCode/negloglik_new.R")
library("xtable")

#######expgamma#####
filename <- "expgamma"
ks <- c(5,10,20)
num_files <- 10
nll_results_master <- NULL
test <- TRUE
if (test){
  fileext <- ""
} else {
  fileext <- "train"
}
#train <- "" #for test data


for (k in ks){
  #extract loss values
  nll_results <- extract_nlltable(filename, k, num_files, 
                                  distr = "gamma", test = test)
  
  if (is.null(nll_results_master)){
    nll_results_master <- nll_results
  } else {
    nll_results_master <- rbind(nll_results_master, nll_results)
  }
  
}
print(xtable(nll_results_master, digits = 4, type = "latex"), 
      file = paste0("tex_tables/", filename, fileext, "results.tex"))
saveRDS(nll_results_master, paste0("RCode/_nll_res_", filename, fileext,".rds"))


#######expgamma#####
filename <- "expnormal"
ks <- c(5,10,20)
num_files <- 10
nll_results_master <- NULL

for (k in ks){
  #extract loss values
  nll_results <- extract_nlltable(filename, k, num_files, 
                                  distr = "normal", test = test)
  
  if (is.null(nll_results_master)){
    nll_results_master <- nll_results
  } else {
    nll_results_master <- rbind(nll_results_master, nll_results)
  }
  
}
print(xtable(nll_results_master, digits = 4, type = "latex"), 
      file = paste0("tex_tables/", filename, fileext, "results.tex"))
saveRDS(nll_results_master, paste0("RCode/_nll_res_", filename, fileext,".rds"))



#######expgamma#####
filename <- "sinnormal"
ks <- c(5,10,20)
num_files <- 10
nll_results_master <- NULL

for (k in ks){
  #extract loss values
  nll_results <- extract_nlltable(filename, k, num_files, 
                                  distr = "normal", test = test)
  
  if (is.null(nll_results_master)){
    nll_results_master <- nll_results
  } else {
    nll_results_master <- rbind(nll_results_master, nll_results)
  }
  
}
print(xtable(nll_results_master, digits = 4, type = "latex"), 
      file = paste0("tex_tables/", filename,fileext, "results.tex"))
saveRDS(nll_results_master, paste0("RCode/_nll_res_", filename, fileext,".rds"))


#
#mytab <- extract_nlltable(filename, k, 10, distr = "normal")
#mydat <- read.csv(paste0(filename, k, "d_", 1, ".csv"))
#crps_norm(mydat$y, mydat$gam_mean, mydat$gam_scale)
