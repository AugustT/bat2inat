source('species_table.R')
source('call_metadata.R')
source('write_spectro.R')
source('send_observation.R')
source('filter_calls.R')
library(reticulate)

pynat <- import('pyinaturalist')

# files <- file <- 'data/BARBAR_20210526_221302.wav'

files <- list.files(path = choose.dir(getwd()),
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)

pbapply::pblapply(X = files, FUN = send_observation)
