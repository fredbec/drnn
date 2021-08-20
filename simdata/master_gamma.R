setwd("C:/Users/rike/Nextcloud/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/simdata")

#load simdata gamma function
source("exp_gamma.R")

#how many sets to simulate?
n_sets <- 5

#number of observations per dataset
n <- 15000

#how many predictors?
k <- 5

#random seed
set.seed(2015)

#simulate data
for (i in 1:n_sets){
  expdat <- exp_gamma(n, k, stand = TRUE)
  write.csv(expdat, 
            file = paste0("data/", "expgamma", k, "d", "_", i, ".csv"))
}

################INCLUDE SHUFFLE DATA###############

#newdat <- expdat %>% filter(x1 > 0.9, x2 > 0.8, x3 < 0.2)
#newdat
#hist(newdat$y, breaks = 50)
