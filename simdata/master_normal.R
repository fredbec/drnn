path <- "C:/Users/rike/Nextcloud/Uni/Master_toclean/4. Semester (SoSe21)/DDR_Project/drnn/drnn/easy_simfcts"

set.seed(1042)

#source(paste0(path, "/sinus.R"))
#source(paste0(path, "/sinus_multiv.R"))
source(paste0(path, "/sinusmd.R"))
n <- 10000

sindat <- sinusmd(10000, k = 4, seed = 2403)#xrange = c(-10, 20))
write.csv(sindat, paste0(path, "/sinus4d.csv"))


set.seed(1042)
source(paste0(path, "/exp_gamma.R"))
expdat <- exp_gamma(100000, 1, stand = FALSE)
write.csv(expdat, paste0(path, "/gamma1d.csv"))

expdat <- exp_gamma(100000, 3, stand = FALSE)
write.csv(expdat, paste0(path, "/gamma3d.csv"))


