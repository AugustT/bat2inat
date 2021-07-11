send_observations <- function(files, post = TRUE, token){
  
  log <- data.frame(sp = NULL,
                    lat = NULL,
                    long = NULL,
                    date = NULL)
  
  for(i in files){
    
    cat(paste0('\n', which(i == files), '/',
               length(files), '\n'))
    
    resp <- send_observation(file = i, 
                             post = post, 
                             token = token,
                             log = log)
    
    if(!is.null(resp)){
    
      log <- rbind(log, 
                   data.frame(sp = md$sp,
                              lat = md$lat,
                              long = md$long,
                              date = md$date))
    }
  }
  
  cat('\nCOMPLETE')
  
}