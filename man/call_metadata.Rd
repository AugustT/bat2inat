\name{call_metadata}
\alias{call_metadata}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
call_metadata(file, verbose = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file}{
%%     ~~Describe \code{file} here~~
}
  \item{verbose}{
%%     ~~Describe \code{verbose} here~~
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
function (file, verbose = TRUE) 
{
    if (verbose) 
        cat("Extracting call metadata")
    md <- bioacoustics:::guano_md(file)
    date <- strsplit(md$`Original Filename`, "_")[[1]][1]
    formatted_date <- paste0(substr(date, 1, 4), "/", substr(date, 
        5, 6), "/", substr(date, 7, 8))
    time <- strsplit(md$`Original Filename`, "_")[[1]][2]
    formatted_time <- paste0(substr(time, 1, 2), ":", substr(time, 
        3, 4), ":", substr(time, 5, 6))
    sp <- ifelse(test = md$`Species Auto ID` == md$`Species Manual ID`, 
        yes = md$`Species Auto ID`, no = md$`Species Manual ID`)
    sp_tab <- species_table()
    sp_lookup <- sp_tab[[sp]]
    if (is.null(md$`Loc Position Lat`) | is.null(md$`Loc Position Lon`)) {
        if (verbose) 
            cat("\tNo Location - Skipped\n")
        return(NULL)
    }
    else {
        if (verbose) 
            cat("\tDone\n")
        return(list(lat = md$`Loc Position Lat`, long = md$`Loc Position Lon`, 
            sp = sp_lookup, model = md$Model, firmware = md$`Firmware Version`, 
            settings = md$`WA|Song Meter|Audio settings`, sampling = md$Samplerate, 
            date = formatted_date, time = formatted_time))
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
