library("dplyr")
scoretable <- function(nll_table, num_files = 10, sets = 3, rel = TRUE, lin = TRUE){
  
  if(lin){
    res <- data.frame(matrix(ncol = 7,
                             nrow = sets*num_files))
    names(res) <- c("filename", "nll_cub", "crps_cub", "mse_cub",
                    "nll_lin", "crps_lin", "mse_lin")
  } else {
    res <- data.frame(matrix(ncol = 4,
                             nrow = sets*num_files))
    names(res) <- c("filename", "nll_cub", "crps_cub", "mse_cub")
  }
  
  #remove file number (for grouping file types)
  res$filename <- gsub("*\\_.*", "", nll_table$filename)
  
  #indicator for negative values in nll
  #if nll is negative, we have to divide the other way (because then,
  #larger absolute values are better)
  isneg <- (nll_table$nll_ddl<0 & nll_table$nll_gam<0)
  res$nll_cub[isneg] <- (nll_table$nll_gam[isneg] / nll_table$nll_ddl[isneg])
  res$nll_cub[!isneg] <- (nll_table$nll_ddl[!isneg] / nll_table$nll_gam[!isneg])
  
  
  #crps and mse can only take on positive values
  res$crps_cub <- (nll_table$crps_ddl / nll_table$crps_gam)
  res$mse_cub <- (nll_table$mse_ddl / nll_table$mse_gam)
  
  if (lin){
    res$nll_lin[isneg] <- (nll_table$nll_gamlin[isneg] / nll_table$nll_ddl[isneg])
    res$nll_lin[!isneg] <- (nll_table$nll_ddl[!isneg] / nll_table$nll_gamlin[!isneg])
    res$crps_lin <- (nll_table$crps_ddl / nll_table$crps_gamlin)
    res$mse_lin <- (nll_table$mse_ddl / nll_table$mse_gamlin)
  }

  
  #take means over the 10 runs
  if(lin){
    res <- res %>% 
      group_by(filename) %>%
      summarize(nll_cub = mean(nll_cub),
                crps_cub = mean(crps_cub),
                mse_cub = mean(mse_cub),
                nll_lin = mean(nll_lin),
                crps_lin = mean(crps_lin),
                mse_lin = mean(mse_lin))
  } else {
    res <- res %>% 
      group_by(filename) %>%
      summarize(nll_cub = mean(nll_cub),
                crps_cub = mean(crps_cub),
                mse_cub = mean(mse_cub))
  }
  return(res)
}

#nll_tab <- readRDS(paste0("RCode/_nll_res_", "expnormal", ".rds"))
#scoretable(nll_tab)
