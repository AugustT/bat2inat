for(script in list.files('functions', full.names = T)) source(script)
library(reticulate)

pynat <- import('pyinaturalist')

# files <- file <- 'data/PIPPIP_20210526_221643.wav'

files <- list.files(path = 'C:\\Users\\t_a_a\\OneDrive - UKCEH\\Bat audio - EM touch\\West Barn/',
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)
files

# ids <- lapply(X = files,
#               FUN = send_observation,
#               post = TRUE)

load('token.rdata')

send_observations(files = files[1:5], post = TRUE, token = token)
