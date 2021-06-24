send_observation <- function(file, post = TRUE, verbose = TRUE, token){
  
  if(verbose) cat(paste0('#', basename(file), '#\n'))
  
  # get metadata
  md <- call_metadata(file)
  
  # filter calls
  TD <- filter_calls(file)
  
  # create spectrogram
  png <- write_spectro(file, TD, samp_freq = md$sampling)
  
  # browseURL(dirname(TD$filtered_calls_image))
  
  # load token
  if(post){
    if(verbose) cat('Uploading observation data')
    token <- pynat$get_access_token(token[[1]],
                                    token[[2]],
                                    token[[3]],
                                    token[[4]])
    
    if(is.null(TD$freq_peak)){
      
      desc <- paste('Recorded on', md$model, md$firmware, '\n',
                    'Call parameters could not automatically be extracted',
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
    
    response <- pynat$create_observation(
      species_guess = md$sp,
      observed_on = paste(md$date, md$time),
      description = desc,
      latitude = md$lat, 
      longitude = md$long,
      photos = png,
      sounds = file,
      access_token = token,
      observation_fields = list('567' = paste(md$model, md$firmware), #model
                                '4936' = md$sampling/1000,
                                '12583' = md$time) #sampling rate (kHz)
    )
    if(verbose) cat('\tDone\n\n')
    return(response[[1]][['id']])
  }
  
  return(NULL)

}