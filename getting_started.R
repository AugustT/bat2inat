# Getting started
# install.packages('reticulate')
library(reticulate)

# Install the iNat python package https://pypi.org/project/pyinaturalist/
py_install("pyinaturalist==0.14.0dev374", pip = TRUE)

# Create an app on iNat here: https://www.inaturalist.org/oauth/applications/new
# save out id and secret to an object and dont share with others
load('token.rdata')

# Start using the package
pynat <- import('pyinaturalist')

# get token
token <- pynat$get_access_token(token[[1]],
                                token[[2]],
                                token[[3]],
                                token[[4]])

# Submit an observation
response <- pynat$create_observation(
  species_guess = 'cheetah',
  observed_on = '2021-05-02 11:23',
  description='This is a bat auto upload',
  latitude = 51.599840854449226, 
  longitude = -1.130838820690541,
  positional_accuracy = 23, # GPS accuracy in meters
  access_token = token
)

# Observed on (date)
response[[1]]$observed_on

# Save the new observation ID
new_observation_id <- response[[1]][['id']]

# Delete the observation
pynat$delete_observation(new_observation_id,
                         token)
