call_metadata <- function(file, verbose = TRUE){
  
  if(verbose) cat('Extracting call metadata')
  
  md <- bioacoustics:::guano_md(file)
  
  date <- strsplit(md$`Original Filename`, '_')[[1]][1]
  formatted_date <- paste0(substr(date,1,4), '/',
                           substr(date,5,6), '/',
                           substr(date,7,8))
  time <- strsplit(md$`Original Filename`, '_')[[1]][2]
  formatted_time <- paste0(substr(time,1,2), ':',
                           substr(time,3,4), ':',
                           substr(time,5,6))
  
  sp <- ifelse(test = md$`Species Auto ID` == md$`Species Manual ID`,
               yes = md$`Species Auto ID`,
               no = md$`Species Manual ID`)
  
  sp_tab <- species_table()
  sp_lookup <- sp_tab[[sp]]
  
  if(verbose) cat('\tDone\n')
  
  list(lat = md$`Loc Position Lat`,
       long = md$`Loc Position Lon`,
       sp = sp_lookup, 
       model = md$Model, 
       firmware = md$`Firmware Version`,
       settings = md$`WA|Song Meter|Audio settings`,
       sampling = md$Samplerate, 
       date = formatted_date, 
       time = formatted_time)
  
}