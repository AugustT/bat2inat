library(bat2inat)

files <- list.files(path = file.path(find.package('bat2inat'), 'data'),
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)
files

load('token.rdata')

# Test account
token$username <- 'bat2inat'
token$password <- 'test123'

bat2inat::send_observations(files = files[1],
                            post = FALSE, 
                            token = token)
