#' @export
call_metadata <-
function(file, name = NULL, verbose = TRUE){
  
  if(verbose) cat('Extracting call metadata')
  
  md <- bioacoustics:::guano_md(file)
  
  if(length(md)==0){
    
    if(verbose) cat('\tNo metadata found - Skipped\n')
    return(NULL)
    
  } else {
    
    fname <- gsub('.wav', '', md$`Original Filename`)
    sp_fname <- strsplit(fname, '_')
    date <- sp_fname[[1]][length(sp_fname)-1]
    
    formatted_date <- paste0(substr(date,1,4), '/',
                             substr(date,5,6), '/',
                             substr(date,7,8))
    time <- strsplit(fname, '_')[[1]][2]
    formatted_time <- paste0(substr(time,1,2), ':',
                             substr(time,3,4), ':',
                             substr(time,5,6))
    
    if('Species Auto ID' %in% names(md) & 
       'Species Manual ID' %in% names(md)){
      
      sp <- ifelse(test = md$`Species Auto ID` == md$`Species Manual ID`,
                   yes = md$`Species Auto ID`,
                   no = md$`Species Manual ID`)
      
    } else if('Species Auto ID' %in% names(md)) {
      
      sp <- md$`Species Auto ID`
      
    } else if('Species Manual ID' %in% names(md)){
      
      sp <- md$`Species Manual ID`
      
    } else {
      
      if(is.null(name)) name <- basename(file)
      sp <- strsplit(name, '_')[[1]][1]
      
    }
    
    sp_tab <- species_table()
    sp_lookup <- sp_tab[[sp]]
    
    if(is.null(md$`Loc Position Lat`) | is.null(md$`Loc Position Lon`)){
      
      if(verbose) cat('\tNo Location - Skipped\n')
      return(NULL)
      
    } else {
      
      if(verbose) cat('\tDone\n')
      return(list(lat = md$`Loc Position Lat`,
                  long = md$`Loc Position Lon`,
                  sp = sp_lookup, 
                  model = md$Model, 
                  firmware = md$`Firmware Version`,
                  settings = md$`WA|Song Meter|Audio settings`,
                  sampling = md$Samplerate, 
                  date = formatted_date, 
                  time = formatted_time))  
      
    }
  }
}
