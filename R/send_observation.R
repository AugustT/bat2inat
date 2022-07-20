#' @export
#' @import reticulate
#' @import geosphere
#' @import soundgen
#' @import av
send_observation <-
function(file,
         post = TRUE,
         verbose = TRUE,
         token,
         post_duplicates = FALSE,
         radius = 10,
         log = NULL){
  
  if(verbose) cat(paste0('#', basename(file), '#\n'))
  
  pynat <- import('pyinaturalist')
  
  # get metadata
  md <- call_metadata(file, verbose = verbose)
  
  if(is.null(md)){
    
    return(NULL)
    
  } else {
    
    if(!is.null(md$sp)){
    
      # check against log
      log_check <- log[log$sp == md$sp &
                         # log$lat == md$lat &
                         # log$long == md$long &
                         log$date == md$date, ]
      
      if(nrow(log_check) > 0){
        
        dists <- NULL
        
        # Measure distances
        for(i in 1:nrow(log_check)){
          
          dists <- c(dists,
                     distm(c(md$long, md$lat),
                           c(log_check$long[i], log_check$lat[i]),
                           fun = distHaversine))
        }
        
        if(any(dists < radius)){
          
          cat('Duplicate in this batch',
              paste0('(', round(min(dists)), 'm)'),
              '- skipping\n\n')
          return(NULL)
          
        }
      }
    }
  } 
  
  if(!is.null(md$sp)){
    
    # Check we don't have a duplicate observation already
    dupe <- is_duplicate(md = md,
                         radius = 10,
                         username = token$username)
    
    if(dupe) return(NULL)
    
  }
  
  # At this point if there is not species ID
  # set it to 'life'
  if(is.null(md$sp)) md$sp <- 'life'
  
  # filter calls
  TD <- filter_calls(file, verbose = verbose)
  
  # create spectrogram
  png <- write_spectro(file, TD, samp_freq = md$sampling,
                       verbose = verbose)
  
  # create animation
  # install.packages("soundgen")
  # 
  # soundgen::shiftPitch(file, timeStretch = 10)
  # 
  # 
  # tmp_vid1 <- tempfile(fileext = '.wav')
  # tmp_vid2 <- tempfile(fileext = '.mp3')
  # 
  # seewave::  seewave::savewav(wave = tpV, filename = tmp_vid1)
  # str(read_audio_fft(audio = file, sample_rate = 26500))
  # 
  # t <- tuneR::readWave(file)
  # t2 <- seewave::resamp(wave = t,
  #                       f = t@samp.rate,
  #                       g = t@samp.rate/10)
  # str(t2)
  # 
  # 
  # tv <- av::av_spectrogram_video(audio = tmp_vid1,
  #                                output = tmp_vid2,
  #                                framerate = 1,
  #                                verbose = TRUE,
  #                                width = 300,
  #                                height = 300,
  #                                units = "px")
  # utils::browseURL(tmp_vid)
  # 
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
                  'Number of good quality calls:', length(TD$freq_peak), '\n',
                  'Av. peak frequency (kHz):', round(median(TD$freq_peak/1000)), '\n',
                  'Av. max frequency (kHz):', round(median(TD$freq_max/1000)), '\n',
                  'Av. min frequency (kHz):', round(median(TD$freq_min/1000)), '\n',
                  'Call durations (ms):', round(median(TD$call_duration), digits = 1), '\n',
                  'Recorder settings\n',
                  md$settings)
    
  }
  
  # Set up observation fields
  of <- list('567' = paste(md$model, md$firmware), #model
             '4936' = md$sampling/1000,
             '12583' = md$time,
             '11667' = basename(file))
  
  # Add average frequency if its there
  if(!is.null(TD$freq_peak)){
    
    of <- c(of, '308' = round(median(TD$freq_peak/1000)))
    
  }
 
  if(post){
    
    response <- pynat$create_observation(
      species_guess = ifelse(is.null(md$sp),
                             'life',
                             md$sp),
      observed_on = paste(md$date, md$time),
      description = desc,
      latitude = md$lat, 
      longitude = md$long,
      tag_list = 'Bat2iNat',
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
