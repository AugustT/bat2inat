library(bat2inat)

files <- list.files(path = 'C:\\Users\\t_a_a\\OneDrive - UKCEH\\Bat audio - EM touch\\Wytham/2021_08_21/',
                    pattern = '.wav',
                    recursive = T,
                    full.names = T)
files
# 
# for(i in 5){
#   x <- filter_calls(files[i])
#   print(length(x$freq_peak))
#   print(median(x$freq_peak))
# }
# 
# x
# 
# library(bioacoustics)
# data(myotis)
# blob_detection(myotis, time_exp = 10,
#                contrast_boost = 30, 
#                bg_substract = 30, spectro_dir = getwd())
# threshold_detection(myotis, time_exp = 10,
#                     spectro_dir = getwd())

load('token.rdata')

# Test account
# token$username <- 'bat2inat'
# token$password <- 'test123'

send_observations(files = files,
                  post = FALSE,
                  token = token,
                  radius = 15)
