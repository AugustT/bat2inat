\name{filter_calls}
\alias{filter_calls}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
filter_calls(file, verbose = TRUE, plot = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file}{
%%     ~~Describe \code{file} here~~
}
  \item{verbose}{
%%     ~~Describe \code{verbose} here~~
}
  \item{plot}{
%%     ~~Describe \code{plot} here~~
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
function (file, verbose = TRUE, plot = FALSE) 
{
    if (verbose) 
        cat("Isolating calls")
    if (plot) {
        tempD <- tempdir()
        unlink(file.path(tempD, "spectrograms"), recursive = TRUE)
        unlink(list.files(tempD, pattern = "^spectrograms.+html$", 
            full.names = TRUE))
    }
    else {
        tempD <- NULL
    }
    TD <- bioacoustics::threshold_detection(threshold = 10, file, 
        spectro_dir = tempD, ticks = TRUE, acoustic_feat = TRUE)
    if (verbose) 
        cat("\t\t\tDone\n")
    if (plot) {
        fp <- file.path(tempD, "filtered_calls.png")
        if (verbose) 
            cat(paste("Plotting", length(TD$data$event_data$freq_max_amp), 
                "calls"))
        webshot::webshot(url = list.files(tempD, pattern = "^spectrograms.+html$", 
            full.names = TRUE), file = fp, vheight = 500, vwidth = 600)
        if (verbose) 
            cat("\t\tDone\n")
    }
    else {
        fp <- NULL
    }
    return(list(filtered_calls_image = fp, freq_peak = TD$data$event_data$freq_max_amp, 
        freq_max = TD$data$event_data$freq_max, freq_min = TD$data$event_data$freq_min, 
        call_duration = TD$data$event_data$duration, call_start = TD$data$event_start, 
        call_end = TD$data$event_end))
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
