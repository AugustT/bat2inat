send_observation <- function(file){
  
  # get metadata
  md <- call_metadata(file)
  
  # create spectrogram
  png <- write_spectro(file)
  
  # load token
  load("C:/Users/t_a_a/OneDrive - NERC/bat2inat/token.rdata")
  token <- pynat$get_access_token(token[[1]],
                                  token[[2]],
                                  token[[3]],
                                  token[[4]])
  
  response <- pynat$create_observation(
    species_guess = md$sp,
    observed_on_string = md$date,
    description = paste('Recorded on', md$model, md$firmware, '\n',
                        'Recorder settings\n',
                        md$settings),
    latitude = md$lat, 
    longitude = md$long,
    photos = png,
    sounds = file,
    access_token = token,
    observation_fields = list('567' = paste(md$model, md$firmware), #model
                              '4936' = md$sampling/1000) #sampling rate (kHz)
  )

  # pic_response <- pynat$add_photo_to_observation(
  #   response[[1]][['id']],
  #   png,
  #   access_token = token
  # )
  
  return(response[[1]][['id']])
  
}