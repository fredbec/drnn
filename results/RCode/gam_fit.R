library("mgcv")
setwd("C:/Users/rike/Nextcloud/Uni/Master/4. Semester (SoSe21)/DDR_Project/drnn/results")
gam_fit <- function(filename, k, type = c("linear", "cubic"),
                    distr = c("gamma", "normal"), num_files = 10){
  
  pred_names <- sapply(1:k, function(k1) paste0("x",k1))
  
  #generate formulas
  if (type == "cubic"){
    reg_terms <- sapply(pred_names, function(x) paste0("s(", x, ", bs = 'cr' )"))
  } else if (type == "linear"){
    reg_terms <- pred_names
  }
  
  form_loc <- as.formula(paste("y", paste(reg_terms, collapse = " + "), 
                               sep = " ~ "))
  form_scale <- as.formula(paste(" ", paste(reg_terms, collapse = " + "), 
                                 sep = " ~ "))


  
  for (i in 1:num_files){ ####replace with num_files
    dat <- read.csv(paste0(filename, k, "d_", i, ".csv"))
    #subset vector (exclude test set from fit)
    dat$sub_id <- dat$testid == 0
    
    
    if (distr == "gamma"){
      
      gammod <- gam(list(form_loc, form_scale), 
                    data = dat, family = gammals,
                    subset = sub_id)
      
      preds <- predict.gam(gammod, dat, type = "response")
      
      
      loc_pred <- preds[,1]
      scale_pred <- exp(preds[,2]) #convert scale to data scale
      
      if (type == "cubic"){
        dat$gam_shape <- 1/(scale_pred)
        dat$gam_scale <- (scale_pred) * loc_pred
      } else if (type == "linear"){
        dat$gamlin_shape <- 1/(scale_pred)
        dat$gamlin_scale <- (scale_pred) * loc_pred
      }
      
    } else if (distr == "normal"){
      
      gammod <- gam(list(form_loc, form_scale), 
                    data = dat, family = gaulss,
                    subset = sub_id)
      
      #return(gammod)
      preds <- predict.gam(gammod, dat, type = "response")
      
      
      loc_pred <- preds[,1]
      scale_pred <- 1/(preds[,2]) #convert scale to data scale
      
      
      if (type == "cubic"){
        dat$gam_mean <- loc_pred
        dat$gam_scale <- scale_pred
      } else if (type == "linear"){
        dat$gamlin_mean <- loc_pred
        dat$gamlin_scale <- scale_pred
      }
    }
    write.csv(dat, paste0(filename, k, "d_", i, ".csv"))
  }
  
}
