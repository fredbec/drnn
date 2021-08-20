library(tidyverse)
library(gamlss)

source("C:/Users/rike/Desktop/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/drnn/simdata/soep_simdata_fct.R")
sdatm <- read.csv("C:/Users/rike/ownCloud/Friederike/DDR/SOEP_Data/soepm.csv")

#age group variable
cutage <- c(0, seq(20, 100, by = 10))
sdatm$agegroup <- cut(sdatm$age, breaks = cutage, label = 1:9)


####categorical var's distributions####
#now, find the 'true' distribution of the categorical variables 
#conditioned on age from the data

#family status
mprobs <- sdatm %>%
  group_by(agegroup) %>%
  summarize(mar1 = mean(mar1), #get means by age group for each status
            mar2 = mean(mar2),
            mar3 = mean(mar3),
            mar4 = mean(mar4)) %>%
  dplyr::select(mar1, mar2, mar3, mar4) %>% #keep only perc's and convert to matrix
  as.matrix()

#education
eduprobs <- sdatm %>%
  group_by(agegroup) %>%
  summarize(edu1d = mean(edu1d),
            edu2d = mean(edu2d),
            edu3d = mean(edu3d),
            edu4d = mean(edu4d)) %>%
  dplyr::select(edu1d, edu2d, edu3d, edu4d) %>%
  as.matrix()

#income mean and standard deviatiob
yparams <- sdatm %>%
  group_by(agegroup) %>%
  summarize(ymean = mean(neYl),
            ysd = sd(neYl)) %>%
  dplyr::select(ymean, ysd) %>%
  as.matrix()

#DNat (currently not correlated with age in simulation function)
#pdnat <- sdatm %>%
#  group_by(agegroup) %>%
#  summarize(ymean = mean(DNat)) %>%
#  dplyr::select(ymean) %>%
#  as.matrix()


#get overall percentage of East-West (OW) and Dnat
pdnat <- sum(sdatm$DNat==1)/nrow(sdatm)
peawe <- sum(sdatm$OW==1)/nrow(sdatm)

##find out coefficients for normal distribution
gammaf <- gamlss(mPCS ~ age + agesq + neYl + DNat +
                   edu2d + edu3d + edu4d + 
                   mar2 + mar3 + mar4 + OW +
                   re(random = ~1|bula), 
                 sigma.formula = mPCS ~ age + agesq + neYl + DNat +
                   edu2d + edu3d + edu4d + 
                   mar2 + mar3 + mar4 + OW +
                   re(random = ~1|bula), 
                 data = soepf,
                 weights = w8,
                 family = NO(mu.link = "identity",
                             sigma.link = "log"))
f_mu_coef <- data.frame(t(as.matrix(gammaf$mu.coefficients[1:12])))
f_sigma_coef <- data.frame(t(as.matrix(gammaf$sigma.coefficients[1:12])))

gammam <- gamlss(mPCS ~ age + agesq + neYl + DNat +
                   edu2d + edu3d + edu4d + 
                   mar2 + mar3 + mar4 + OW +
                   re(random = ~1|bula), 
                 sigma.formula = mPCS ~ age + agesq + neYl + DNat +
                   edu2d + edu3d + edu4d + 
                   mar2 + mar3 + mar4 + OW +
                   re(random = ~1|bula), 
                 data = soepm,
                 weights = w8,
                 family = NO(mu.link = "identity",
                             sigma.link = "log"))

m_mu_coef <- data.frame(t(as.matrix(gammam$mu.coefficients[1:12])))
m_sigma_coef <- data.frame(t(as.matrix(gammam$sigma.coefficients[1:12])))



########Simulate Data#######
simdat_soepm <- simdata_soep_fct(distr = "normal", N = 10000, 
                                 mu_coef = m_mu_coef, sigma_coef = m_sigma_coef,
                                 cutage = cutage, pmars = mprobs, 
                                 pedus = eduprobs, yparams = yparams,
                                 peawe = peawe, pdnat = pdnat, 
                                 scaling = "norm", noise = TRUE,
                                 sim_seed = 2912)
csvfile_name <- "simdata_norm.csv"
write.csv(simdat_soepm, paste0("C:/Users/rike/ownCloud/Friederike/DDR/data/", csvfile_name), row.names = FALSE)

#write.csv(simdat_soepm, paste0(path, "/data/", "fulldatasim_norm", ".csv"), row.names = FALSE)
