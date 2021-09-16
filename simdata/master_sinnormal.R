rm(list = ls())

setwd("C:/Users/rike/Nextcloud/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/simdata")

#load simdata exp_normal function
source("sin_normal.R")

start_i <- 0 #sets 1-10
#how many sets to simulate?
n_sets <- 10

#number of observations per dataset
n <- 15000

#how many predictors?
k <- 5

#random seed
set.seed(2912) #this was the one used for sets 1-10

#simulate data
for (i in (start_i+1):(start_i+n_sets)){
  sindat <- sin_normal(n, k, stand = TRUE)
  write.csv(sindat, 
            file = paste0("data/", "sinnormal", k, "d", "_", i, ".csv"))
}


######################k = 10##############################

start_i <- 0 #sets 1-10
#how many sets to simulate?
n_sets <- 10

#number of observations per dataset
n <- 15000

#how many predictors?
k <- 10

#random seed
set.seed(56234) #this was the one used for sets 1-10

#simulate data
for (i in (start_i+1):(start_i+n_sets)){
  sindat <- sin_normal(n, k, stand = TRUE)
  write.csv(sindat, 
            file = paste0("data/", "sinnormal", k, "d", "_", i, ".csv"))
}



######################k = 20##############################

start_i <- 0 #sets 1-10
#how many sets to simulate?
n_sets <- 10

#number of observations per dataset
n <- 15000

#how many predictors?
k <- 20

#random seed
set.seed(2527) #this was the one used for sets 1-10

#simulate data
for (i in (start_i+1):(start_i+n_sets)){
  sindat <- sin_normal(n, k, stand = TRUE)
  write.csv(sindat, 
            file = paste0("data/", "sinnormal", k, "d", "_", i, ".csv"))
}