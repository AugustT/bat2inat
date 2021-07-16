\name{is_duplicate}
\alias{is_duplicate}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
is_duplicate(md, radius = 10, username, verbose = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{md}{
%%     ~~Describe \code{md} here~~
}
  \item{radius}{
%%     ~~Describe \code{radius} here~~
}
  \item{username}{
%%     ~~Describe \code{username} here~~
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
function (md, radius = 10, username, verbose = TRUE) 
{
    if (verbose) 
        cat("Searching for duplicates")
    q <- pynat$search(q = md$sp, sources = "taxa", per_page = 1)
    if (q$total_results == 0) {
        warning(paste0("Name ", "\"", md$sp, "\"", " cannot be matched to a species name on iNaturalist"))
        return(FALSE)
        if (verbose) 
            cat("\tDone\n")
    }
    id <- q$results[[1]]$record$id
    rtn <- pynat$get_observations(user_id = username, taxon_id = id, 
        observed_on = md$date, lat = md$lat, lng = md$long, radius = radius/1000, 
        count_only = TRUE)
    dupe <- ifelse(test = rtn$total_results > 0, yes = TRUE, 
        no = FALSE)
    if (verbose) {
        if (dupe) {
            cat("\tDuplicate online - skipping\n\n")
        }
        else {
            cat("\tUnique - proceeding\n")
        }
    }
    return(dupe)
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
