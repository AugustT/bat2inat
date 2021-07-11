send_observation <- function(file,
                             post = TRUE,
                             verbose = TRUE,
                             token,
                             post_duplicates = FALSE,
                             radius = 10,
                             log = NULL){
  
  if(verbose) cat(paste0('#', basename(file), '#\n'))
  
  # get metadata
  md <- call_metadata(file, verbose = verbose)
  
  if(is.null(md)){
    
    return(NULL)
    
  } else {
    
    # check against log
    log_check <- log[log$sp == md$sp &
                     log$lat == md$lat &
                     log$long == md$long &
                     log$date == md$date, ]

    if(nrow(log_check) > 0){
      
      cat('\nDuplicate in this batch - skipping\n\n')
    
    }
        
  } 
  
  # Check we don't have a duplicate observation already
  dupe <- is_duplicate(md = md,
                       radius = 10,
                       username = token$username)
  
  if(dupe) return(NULL)
  
  # filter calls
  TD <- filter_calls(file, verbose = verbose)
  
  # create spectrogram
  png <- write_spectro(file, TD, samp_freq = md$sampling,
                       verbose = verbose)
  
  # browseURL(dirname(TD$filtered_calls_image))
  
  # load token
  if(verbose) cat('Uploading observation data')
  token <- pynat$get_access_token(token[[1]],
                                  token[[2]],
                                  token[[3]],
                                  token[[4]])
  
  if(is.null(TD$freq_peak)){
    
    desc <- paste('Recorded on', md$model, md$firmware, '\n',
                  'Call parameters could not automatically be extracted\n',
                  'Recorder settings\n',
                  md$settings)
    
  } else {
    
    desc <- paste('Recorded on', md$model, md$firmware, '\n',
                  'Number of calls in sequence:', length(TD$freq_peak), '\n',
                  'Peak frequencies (kHz):', paste(round(TD$freq_peak/1000), collapse = ', '), '\n',
                  'Max frequencies (kHz):', paste(round(TD$freq_max/1000), collapse = ', '), '\n',
                  'Min frequencies (kHz):', paste(round(TD$freq_min/1000), collapse = ', '), '\n',
                  'Call durations (ms):', paste(round(TD$call_duration, digits = 1), collapse = ', '), '\n',
                  'Recorder settings\n',
                  md$settings)
    
  }
  
  # Set up observation fields
  of <- list('567' = paste(md$model, md$firmware), #model
             '4936' = md$sampling/1000,
             '12583' = md$time)
  
  # Add average frequency if its there
  if(!is.null(TD$freq_peak)){
    
    of <- c(of, '308' = round(mean(TD$freq_peak/1000)))
    
  }
 
  if(post){
    
    response <- pynat$create_observation(
      species_guess = md$sp,
      observed_on = paste(md$date, md$time),
      description = desc,
      latitude = md$lat, 
      longitude = md$long,
      photos = png,
      sounds = file,
      access_token = token,
      observation_fields = of
    )
    
    if(verbose) cat('\tDone\n\n')
    
    return(list(id = response[[1]][['id']],
                md = md))
    
  } else {
    
    if(verbose) cat('\tSkipped\n\n')
    return(list(id = NULL,
                md = md))
    
  }
}