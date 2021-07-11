for(file in list.files('functions', full.names = T)) source(file)
library(reticulate)

pynat <- import('pyinaturalist')

# files <- file <- 'data/BARBAR_20210526_221302.wav'

files <- list.files(path = "C:\\Users\\t_a_a\\OneDrive - UKCEH\\Bat audio - EM touch\\Wallinigford/2021/89 High street/Session_20210625_221656/",
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)
files

# ids <- lapply(X = files,
#               FUN = send_observation,
#               post = TRUE)

load('token.rdata')

for(i in files){
  cat(paste0('\n', which(i == files), '/',
             length(files), '\n'))
  send_observation(file = i, 
                   post = TRUE, 
                   token = token)
}
cat('\nCOMPLETE')
