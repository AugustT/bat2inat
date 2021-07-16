\name{write_spectro}
\alias{write_spectro}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
write_spectro(file, TD = NULL, samp_freq = 256000, verbose = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file}{
%%     ~~Describe \code{file} here~~
}
  \item{TD}{
%%     ~~Describe \code{TD} here~~
}
  \item{samp_freq}{
%%     ~~Describe \code{samp_freq} here~~
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
function (file, TD = NULL, samp_freq = 256000, verbose = TRUE) 
{
    if (verbose) 
        cat("Creating spectrogram")
    tf1 <- tempfile(fileext = ".png")
    suppressMessages({
        png(filename = tf1, width = 1024, height = 1024 * 0.75)
        fft_data <- av::read_audio_fft(file, window = av::hanning(1024), 
            overlap = 0.5, )
        plot(fft_data, main = "Spectrogram of full sequence")
        dev.off()
        fnames <- tf1
    })
    if (!is.null(TD)) {
        if (!is.null(TD$call_start)) {
            s <- TD$call_start/samp_freq
            e <- TD$call_end/samp_freq
            bin_window <- 0.5
            bins <- sort(table(floor(s/bin_window) * bin_window), 
                decreasing = TRUE)
            bins <- as.numeric(names(bins))
            tf2 <- tempfile(fileext = ".png")
            suppressMessages({
                png(filename = tf2, width = 1024, height = 1024 * 
                  0.75)
                fft_data <- av::read_audio_fft(file, window = av::hanning(512), 
                  overlap = 0.5, start_time = bins[1], end_time = bins[1] + 
                    bin_window)
                plot(fft_data, main = "Part sequence")
                dev.off()
            })
            plot(fft_data, main = "Part sequence")
            fnames <- c(tf2, fnames)
        }
    }
    if (!is.null(TD$filtered_calls_image)) {
        fnames <- c(fnames, TD$filtered_calls_image)
    }
    if (verbose) 
        cat("\t\tDone\n")
    return(fnames)
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
