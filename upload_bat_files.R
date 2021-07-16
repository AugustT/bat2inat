library(bat2inat)

# files <- file <- 'data/PIPPIP_20210526_221643.wav'

files <- list.files(path = 'C:\\Users\\t_a_a\\OneDrive - UKCEH\\Bat audio - EM touch\\West Barn/',
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)
files

load('token.rdata')

token$username <- 'bat2inat'
token$password <- 'test123'

bat2inat::send_observations(files = files[4], post = TRUE, token = token)
