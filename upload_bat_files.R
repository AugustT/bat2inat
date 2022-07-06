library(bat2inat)

files <- list.files(path = file.path(find.package('bat2inat'), 'data'),
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
token$username <- 'bat2inat'
token$password <- 'test123'


bat2inat::send_observations(files = files[1],
                            post = FALSE, 
                            token = token)

