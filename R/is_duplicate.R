#' @export
#' @import reticulate
is_duplicate <-
function(md, radius = 10, username, verbose = TRUE){
  
  if(verbose) cat('Searching for duplicates')
  
  pynat <- import('pyinaturalist')
  
  # get proper name
  q <- pynat$search(q = md$sp, sources = 'taxa', per_page = 1)
  
  if(q$total_results == 0){
    
    warning(paste0('Name ', '"', md$sp, '"', ' cannot be matched to a species name on iNaturalist'))
    return(FALSE)
    if(verbose) cat('\tDone\n')
    
  }
  
  id <- q$results[[1]]$record$id
  
  rtn <- pynat$get_observations(user_id = username,
                                taxon_id = id,
                                observed_on = md$date,
                                lat = md$lat,
                                lng = md$long,
                                radius = radius/1000,
                                count_only = TRUE)
  
  dupe <- ifelse(test = rtn$total_results > 0,
                 yes = TRUE,
                 no = FALSE)
  
  if(verbose){
    
    if(dupe){
      cat('\tDuplicate online - skipping\n\n')
    } else {
      cat('\tUnique - proceeding\n')
    }
    
  } 
  
  return(dupe)
  
}
