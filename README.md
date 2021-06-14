## What is bat2inat

`bat2inat` is a collection of R functions that make it possible for those familiar with R to bulk upload bat call files from wildlife acoustics recorders to iNaturalist. It is important that when uploading bat calls to iNaturalist that as much information as possible is shared to support the verification of the records. `bat2inat` ensures that this is done by uploading date, time, location, call parameters, spectrograms and the sound file to iNaturalist. 

*Please manually check the identification of all calls before uploading to iNaturalist*

## Getting set up

There are a few things you will need to sort out before we can start uploading files.

1) Create an app on iNat here: https://www.inaturalist.org/oauth/applications/new, make not of the application ID and application secret.

2) Save out your id, secret, username and password to an object and don't share it with others. Add it to your `.gitignore` if you are using git.

You can do this last stage like this:

```r
token <- list(username = "<YOUR_USENAME>",
              password = "<YOUR_PASSWORD>",
              app_id = "<APPLICATION_ID>",
              app_secret = "<APPLICATION_SECRET>")

save(token, file = 'token.rdata')
```

3) Install the R packages we will need

```r
list.of.packages <- c('av', 'reticulate',
                     'bioacoustics', 'webshot')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
```

4) Install the pynaturalist package

If you do not have python installed on your system you will be prompted to install miniconda, this is required for the uploader to work so please say 'yes'.

```r
library(reticulate)

py_install("pyinaturalist==0.14.0dev374", pip = TRUE)
```

6) Test out a file upload. If this works you should see a new observation appear in your iNaturalist account

```r
load('token.rdata')

# Start using the package
pynat <- import('pyinaturalist')

# get token
token <- pynat$get_access_token(token[[1]],
                                token[[2]],
                                token[[3]],
                                token[[4]])

# Submit an observation
pynat$create_observation(
  species_guess = 'Chiroptera',
  observed_on = '2021-05-02 11:23',
  description='This is a test upload, not a real observation',
  latitude = 51.5998, 
  longitude = -1.1308,
  positional_accuracy = 10,
  access_token = token
)
```
