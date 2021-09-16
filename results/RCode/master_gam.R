rm(list= ls())
setwd("C:/Users/rike/Nextcloud/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/results")
source("RCode/gam_fit.R")
#source("RCode/extract_nlltable.R")



#######Expgamma files#######
filename <- "expgamma"
ks <- c(5, 10, 20)
num_files <- 10
nll_results_master <- NULL

for (k in ks){
  #fit gam models and save predictions
  #gam_fit(filename, k, type = "cubic", distr = "gamma")
  gam_fit(filename, k, type = "linear", distr = "gamma")
  
  #extract loss values
  #########WAS MOVED TO OWN FILE#########
  #nll_results <- extract_nlltable(filename, num_files)
  
  #if (is.null(nll_results_master)){
  #  nll_results_master <- nll_results
  #} else {
  #  nll_results_master <- rbind(nll_results_master, nll_results)
  #}
}
#print(xtable(nll_results_master, digits = 5, type = "latex"), 
#      file = paste0("tex_tables/", filename, "_results.tex"))#

#nll_results_expgamma <- nll_results_master



#####Expnormal files#########
filename <- "expnormal"
ks <- c(5, 10, 20)
num_files <- 10
nll_results_master <- NULL


for (k in ks){
  #fit gam models and save predictions
  #gam_fit(filename, k, type = "cubic", distr = "normal")
  gam_fit(filename, k, type = "linear", distr = "normal")
  
  #extract loss values
  #nll_results <- extract_nlltable(filename, num_files, distr = "normal")
  
  #if (is.null(nll_results_master)){
  #  nll_results_master <- nll_results
  #} else {
  #  nll_results_master <- rbind(nll_results_master, nll_results)
  #}

}
#print(xtable(nll_results_master, digits = 5, type = "latex"), 
#      file = paste0("tex_tables/", filename, "results.tex"))
#nll_results_expnormal <- nll_results_master


#####Sinnormal files#########
filename <- "sinnormal"
ks <- c(5, 10, 20)
num_files <- 10
nll_results_master <- NULL


for (k in ks){
  #fit gam models and save predictions
  #gam_fit(filename, k, type = "cubic", distr = "normal")
  gam_fit(filename, k, type = "linear", distr = "normal")
  
  #extract loss values
  #nll_results <- extract_nlltable(filename, num_files, distr = "normal")
  
  #if (is.null(nll_results_master)){
  #  nll_results_master <- nll_results
  #} else {
  #  nll_results_master <- rbind(nll_results_master, nll_results)
  #}
  
}
#print(xtable(nll_results_master, digits = 5, type = "latex"), 
#      file = paste0("tex_tables/", filename, "results.tex"))


#negloglik_gamma(mylist$y, mylist$pred_con, mylist$pred_scale)
#negloglik_gamma(mylist$y, mylist$gam_shape, mylist$gam_scale)