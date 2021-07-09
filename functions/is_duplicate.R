# md - metadata returned from call_metadata
# radius - in meters, in which a record is considered a duplicate

is_duplicate <- function(md, radius = 10, username){
  
  # get proper name
  q <- pynat$search(q = md$sp, sources = 'taxa')
  
  if(q$total_results == 0){
    
    warning(paste0('Name ', '"', md$sp, '"', ' cannot be matched to a species name on iNaturalist'))
    return(FALSE)
    
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
  
  return(dupe)
  
}