filter_calls <- function(file, verbose = TRUE){

  if(verbose) cat('Isolating calls')
  
  # Create a temp dir for spectrograms  
  tempD <- tempdir()
  
  # Delete any that are already there
  unlink(file.path(tempD, 'spectrograms'), recursive = TRUE)
  unlink(list.files(tempD, pattern = '^spectrograms.+html$', full.names = TRUE))
  
  # Do call detection
  TD <- bioacoustics::threshold_detection(
    threshold = 10,
    file,
    spectro_dir = tempD,
    ticks = TRUE
  )
  
  if(verbose) cat('\t\t\tDone\n')
  if(verbose) cat(paste('Plotting', length(TD$data$event_data$freq_max_amp), 'calls'))
  
  # save the html as a png
  webshot::webshot(url = list.files(tempD, pattern = '^spectrograms.+html$', full.names = TRUE),
                   file = file.path(tempD, 'filtered_calls.png'), vheight = 500, vwidth = 600)
  
  if(verbose) cat('\t\tDone\n')
  
  # return all the data
  return(list(filtered_calls_image = file.path(tempD, 'filtered_calls.png'),
              freq_peak = TD$data$event_data$freq_max_amp,
              freq_max = TD$data$event_data$freq_max,
              freq_min = TD$data$event_data$freq_min,
              call_duration = TD$data$event_data$duration))
}