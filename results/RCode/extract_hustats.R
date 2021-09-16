extracthu_stats <- function(filename, filenums,
                            num_first = c(1,5)){
  
  #initialize results dataframe
  results <- data.frame(matrix(nrow = length(filenums),
                               ncol = 2 + 2*length(num_first)))
  pastebest <- function(j){
    return(c(paste0("best", j, "_avghl"), 
             paste0("best", j, "_avghu")))
  }
  namesbest <- as.vector(sapply(num_first, pastebest))
  names(results) <- c("type", "dim", namesbest)
  
  results$type <- filename
  
  #start extraction
  for (k in 1:length(filenums)){
    #read in data
    dat <- read.csv(paste0("hu_key_", filename, 
                           filenums[k], "d.csv"))
    
    for (j in num_first){
      #extract architectures as dataframe
      archs <- dat %>%
        group_by(filename) %>%
        arrange(min_val_loss, .by_group = TRUE) %>%
        slice(1:j) %>% #extract best j vals
        ungroup() %>%
        dplyr::select(architecture) %>%
        as.data.frame()
      
      #convert archs to numerical vectors and store in list
      res <- list()
      for (i in 1:nrow(archs)){
        res[[i]] <- as.vector(as.character(archs[i,])) %>%
        {gsub("[[:punct:]]", "",.)} %>%
        {str_split(.," ")[[1]] } %>%
          as.numeric() %>%
          {.[!is.na(.)]}
      }
      
      #average num_hl and num_hu
      #maybe change metrics here?
      lens <- sapply(res, length)
      avg_hu <- sapply(res, 
                       function(x) round(mean(x)))
      
      
      #store results in dataframe
      results[k, "dim"] <- filenums[k]
      results[k,paste0("best", j, "_avghl")] <- mean(lens)
      results[k,paste0("best", j, "_avghu")] <- mean(avg_hu)
    }
  }
  return(results)
}