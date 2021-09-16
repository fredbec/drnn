rm(list = ls())

setwd("C:/Users/rike/Nextcloud/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/simdata")

#load simdata gamma function
source("exp_gamma.R")

######################k = 5##############################
start_i <- 0 #sets 1-5 
start_i <- 5 #sets 6-10
#how many sets to simulate?
n_sets <- 5

#number of observations per dataset
n <- 15000

#how many predictors?
k <- 5

#random seed
set.seed(2012) #this was the one used for sets 1-5
set.seed(48556) #this was the one used for sets 6-10

#simulate data
for (i in (start_i+1):(start_i+n_sets)){
  expdat <- exp_gamma(n, k, stand = TRUE)
  write.csv(expdat, 
            file = paste0("data/", "expgamma", k, "d", "_", i, ".csv"))
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
set.seed(2019) #this was the one used for sets 1-10

#simulate data
for (i in (start_i+1):(start_i+n_sets)){
  expdat <- exp_gamma(n, k, stand = TRUE)
  write.csv(expdat, 
            file = paste0("data/", "expgamma", k, "d", "_", i, ".csv"))
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
set.seed(2019) #this was the one used for sets 1-10

#simulate data
for (i in (start_i+1):(start_i+n_sets)){
  expdat <- exp_gamma(n, k, stand = TRUE)
  write.csv(expdat, 
            file = paste0("data/", "expgamma", k, "d", "_", i, ".csv"))
}





#newdat <- expdat %>% filter(x1 > 0.8, x2 > 0.8, x3 < 0.2)
#newdat
#hist(newdat$y, breaks = 30)
