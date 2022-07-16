# Get all the bat species names from GBIF to inform t he translation from the
# 6 letter codes

EOR <- FALSE
count <- 0
chiro_L <- NULL

while(EOR == FALSE){

  cat(paste(count,'\n'))
  chiro <- rgbif::name_lookup(higherTaxonKey = 734,
                              rank = 'species',
                              status = 'ACCEPTED',
                              start = count)
  chiro_L <- plyr::rbind.fill(chiro_L, chiro$data)
  if(chiro$meta$endOfRecords == TRUE) EOR <- TRUE
  count <- count + 100

}

chiro_list <- do.call(rbind, lapply(chiro_L$canonicalName, FUN = abb_names))

dput(chiro_list)
