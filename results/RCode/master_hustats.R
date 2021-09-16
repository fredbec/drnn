rm(list = ls())

setwd("C:/Users/rike/Nextcloud/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/results")
library("tidyverse")
library("stringr")
library("xtable")

source("RCode/extract_hustats.R")

#hu_expgamma5d_1 <- read.csv("hu_key_expgamma5d_1-5.csv")
#hu_expgamma5d_2 <- read.csv("hu_key_expgamma5d_6-10.csv")

#hu_expgamma5d <- rbind(hu_expgamma5d_1,
#                       hu_expgamma5d_2)

#write.csv(hu_expgamma5d, "hu_key_expgamma5d.csv")

filenums <- c(5, 10, 20)
num_first <- c(1,5)


filename <- "expgamma"
#get hu values
hures <- extracthu_stats(filename, filenums, num_first)


filename <- "expnormal"
#start analysis
temp <- extracthu_stats(filename, filenums, num_first)
hures <- rbind(hures, temp)


filename <- "sinnormal"
#start analysis
temp <- extracthu_stats(filename, filenums, num_first)
hures <- rbind(hures, temp)


print(xtable(hures, type = "latex"), file = "tex_tables/hu_res.tex")
