\name{send_observations}
\alias{send_observations}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
send_observations(files, post = TRUE, token, parallel = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{files}{
%%     ~~Describe \code{files} here~~
}
  \item{post}{
%%     ~~Describe \code{post} here~~
}
  \item{token}{
%%     ~~Describe \code{token} here~~
}
  \item{parallel}{
%%     ~~Describe \code{parallel} here~~
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
function (files, post = TRUE, token, parallel = FALSE) 
{
    log <- data.frame(sp = NULL, lat = NULL, long = NULL, date = NULL)
    for (i in files) {
        cat(paste0("\n", which(i == files), "/", length(files), 
            "\n"))
        resp <- send_observation(file = i, post = post, token = token, 
            log = log)
        if (!is.null(resp)) {
            log <- rbind(log, data.frame(sp = resp$md$sp, lat = resp$md$lat, 
                long = resp$md$long, date = resp$md$date))
        }
    }
    cat("\nCOMPLETE")
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
