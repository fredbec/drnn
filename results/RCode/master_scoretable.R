rm(list = ls())

setwd("C:/Users/rike/Nextcloud/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/results")
source("RCode/scoretable_withlin.R")
sets <- 3
num_files <- 10
numcols <- 7
test <- FALSE
if (test){
  fileext <- ""
} else {
  fileext <- "train"
}

master_score_table <- data.frame(matrix(ncol = numcols,
                                        nrow = 3*sets))

filenames <- c("expgamma", "expnormal", "sinnormal")
k <- 1
for (filename in filenames){
  nll_tab <- readRDS(paste0("RCode/_nll_res_", filename, fileext, ".rds"))
  start <- sets*(k-1)+1
  stop <- k*sets
  curr_tab <- scoretable(nll_tab, num_files)
  master_score_table[(start:stop),] <- curr_tab
  
  k <- k+1
}
names(master_score_table) <- names(curr_tab)

print(xtable(master_score_table, digits = 4, type = "latex"), 
      file = paste0("tex_tables/score_table_withlin_", fileext, ".tex"))
