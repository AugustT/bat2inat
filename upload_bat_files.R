library(bat2inat)

files <- list.files(path = 'C:\\Users\\t_a_a\\OneDrive - UKCEH\\Bat audio - EM touch\\Cholsey marsh - 19_07_21/',
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)
files

load('token.rdata')

# Test account
# token$username <- 'bat2inat'
# token$password <- 'test123'

bat2inat::send_observations(files = files, post = FALSE, token = token)
