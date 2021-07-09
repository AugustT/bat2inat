for(script in list.files('functions', full.names = T)) source(script)
library(reticulate)

pynat <- import('pyinaturalist')

# files <- file <- 'data/PIPPIP_20210526_221643.wav'

files <- list.files(path = 'data/',#"C:\\Users\\tomaug\\OneDrive - UKCEH\\Bat audio - EM touch\\Woolley Grange - Bath - 2021",
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)

# ids <- lapply(X = files,
#               FUN = send_observation,
#               post = TRUE)

load('token.rdata')

for(i in files[1:5]){
  send_observation(file = i, 
                   post = TRUE, 
                   token = token)
}
