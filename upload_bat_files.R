for(file in list.files('functions', full.names = T)) source(file)
library(reticulate)

pynat <- import('pyinaturalist')

# files <- file <- 'data/BARBAR_20210526_221302.wav'

files <- list.files(path = choose.dir(default = getwd()),
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)

# ids <- lapply(X = files,
#               FUN = send_observation,
#               post = TRUE)

load('token.rdata')

send_observation(file = files[1], 
                 post = TRUE, 
                 token = token)
