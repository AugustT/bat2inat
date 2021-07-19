#' @export
filter_calls <-
function(file, verbose = TRUE, plot = FALSE){

  if(verbose) cat('Isolating calls')
  
  # Create a temp dir for spectrograms  
  if(plot){
    
    tempD <- tempdir()
    
    # Delete any that are already there
    unlink(file.path(tempD, 'spectrograms'), recursive = TRUE)
    unlink(list.files(tempD, pattern = '^spectrograms.+html$', full.names = TRUE))
    
  } else {
    
    tempD <- NULL
    
  }
  
  # Do call detection
  suppressMessages({
    TD <- bioacoustics::threshold_detection(
      threshold = 10,
      file,
      spectro_dir = tempD,
      ticks = TRUE,
      acoustic_feat = TRUE
    )  
  })
  
  if(is.null(TD$data)){
    
    if(verbose) cat('\t\t\tNo calls found - Done\n')
    
  } else {
  
    if(verbose) cat('\t\t\tDone\n')
    
  }
  
  if(plot){
    fp <- file.path(tempD, 'filtered_calls.png')
    if(verbose) cat(paste('Plotting', length(TD$data$event_data$freq_max_amp), 'calls'))
    # save the html as a png
    webshot::webshot(url = list.files(tempD, pattern = '^spectrograms.+html$', full.names = TRUE),
                     file = fp, vheight = 500, vwidth = 600)
    if(verbose) cat('\t\tDone\n')
  } else {
    fp <- NULL
  }
  
  # return all the data
  return(list(filtered_calls_image = fp,
              freq_peak = TD$data$event_data$freq_max_amp,
              freq_max = TD$data$event_data$freq_max,
              freq_min = TD$data$event_data$freq_min,
              call_duration = TD$data$event_data$duration,
              call_start = TD$data$event_start,
              call_end = TD$data$event_end))
}
