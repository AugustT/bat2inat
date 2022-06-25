#' @export
call_metadata <-
function(file, verbose = TRUE){
  
  if(verbose) cat('Extracting call metadata')
  
  md <- bioacoustics:::guano_md(file)
  
  formatted_date <- format(md$Timestamp, format = '%Y/%m/%d')
  
  formatted_time <- format(md$Timestamp, format = '%H:%M:%S')
  
  sp <- ifelse(test = md$`Species Auto ID` == md$`Species Manual ID`,
               yes = md$`Species Auto ID`,
               no = md$`Species Manual ID`)
  
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
