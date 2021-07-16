\name{send_observation}
\alias{send_observation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
send_observation(file, post = TRUE, verbose = TRUE, token, post_duplicates = FALSE, radius = 10, log = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file}{
%%     ~~Describe \code{file} here~~
}
  \item{post}{
%%     ~~Describe \code{post} here~~
}
  \item{verbose}{
%%     ~~Describe \code{verbose} here~~
}
  \item{token}{
%%     ~~Describe \code{token} here~~
}
  \item{post_duplicates}{
%%     ~~Describe \code{post_duplicates} here~~
}
  \item{radius}{
%%     ~~Describe \code{radius} here~~
}
  \item{log}{
%%     ~~Describe \code{log} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (file, post = TRUE, verbose = TRUE, token, post_duplicates = FALSE, 
    radius = 10, log = NULL) 
{
    if (verbose) 
        cat(paste0("#", basename(file), "#\n"))
    md <- call_metadata(file, verbose = verbose)
    if (is.null(md)) {
        return(NULL)
    }
    else {
        log_check <- log[log$sp == md$sp & log$lat == md$lat & 
            log$long == md$long & log$date == md$date, ]
        if (nrow(log_check) > 0) {
            cat("Duplicate in this batch - skipping\n\n")
            return(NULL)
        }
    }
    dupe <- is_duplicate(md = md, radius = 10, username = token$username)
    if (dupe) 
        return(NULL)
    TD <- filter_calls(file, verbose = verbose)
    png <- write_spectro(file, TD, samp_freq = md$sampling, verbose = verbose)
    if (verbose) 
        cat("Uploading observation data")
    token <- pynat$get_access_token(token[[1]], token[[2]], token[[3]], 
        token[[4]])
    if (is.null(TD$freq_peak)) {
        desc <- paste("Recorded on", md$model, md$firmware, "\n", 
            "Call parameters could not automatically be extracted\n", 
            "Recorder settings\n", md$settings)
    }
    else {
        desc <- paste("Recorded on", md$model, md$firmware, "\n", 
            "Number of calls in sequence:", length(TD$freq_peak), 
            "\n", "Peak frequencies (kHz):", paste(round(TD$freq_peak/1000), 
                collapse = ", "), "\n", "Max frequencies (kHz):", 
            paste(round(TD$freq_max/1000), collapse = ", "), 
            "\n", "Min frequencies (kHz):", paste(round(TD$freq_min/1000), 
                collapse = ", "), "\n", "Call durations (ms):", 
            paste(round(TD$call_duration, digits = 1), collapse = ", "), 
            "\n", "Recorder settings\n", md$settings)
    }
    of <- list(`567` = paste(md$model, md$firmware), `4936` = md$sampling/1000, 
        `12583` = md$time)
    if (!is.null(TD$freq_peak)) {
        of <- c(of, `308` = round(mean(TD$freq_peak/1000)))
    }
    if (post) {
        response <- pynat$create_observation(species_guess = md$sp, 
            observed_on = paste(md$date, md$time), description = desc, 
            latitude = md$lat, longitude = md$long, photos = png, 
            sounds = file, access_token = token, observation_fields = of)
        if (verbose) 
            cat("\tDone\n\n")
        return(list(id = response[[1]][["id"]], md = md))
    }
    else {
        if (verbose) 
            cat("\tSkipped\n\n")
        return(list(id = NULL, md = md))
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
