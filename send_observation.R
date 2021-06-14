send_observation <- function(file, post = TRUE, verbose = TRUE){
  
  if(verbose) cat(paste0('#', basename(file), '#\n'))
  
  # get metadata
  md <- call_metadata(file)
  
  # create spectrogram
  png <- write_spectro(file)
  
  # filter calls
  TD <- filter_calls(file)
  # browseURL(dirname(TD$filtered_calls_image))
  
  # load token
  if(post){
    if(verbose) cat('Uploading observation data')
    load("C:/Users/t_a_a/OneDrive - NERC/bat2inat/token.rdata")
    token <- pynat$get_access_token(token[[1]],
                                    token[[2]],
                                    token[[3]],
                                    token[[4]])
    
    response <- pynat$create_observation(
      species_guess = md$sp,
      observed_on_string = as.Date(md$date, format = '%Y/%m/%d'),
      description = paste('Recorded on', md$model, md$firmware, '\n',
                          'Number of calls in sequence:', length(TD$freq_peak), '\n',
                          'Peak frequencies (kHz):', paste(round(TD$freq_peak/1000), collapse = ', '), '\n',
                          'Max frequencies (kHz):', paste(round(TD$freq_max/1000), collapse = ', '), '\n',
                          'Min frequencies (kHz):', paste(round(TD$freq_min/1000), collapse = ', '), '\n',
                          'Call durations (ms):', paste(round(TD$call_duration, digits = 1), collapse = ', '), '\n',
                          'Recorder settings\n',
                          md$settings),
      latitude = md$lat, 
      longitude = md$long,
      photos = c(png, TD$filtered_calls_image),
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