write_spectro <- function(file){
  wav <- bioacoustics::read_audio(file)
  
  tf <- tempfile(fileext = '.png')
  suppressMessages({
    png(filename = tf, width = 1024, height = 1024*0.75)
    seewave::spectro(wav,
                     flim = c(10,100),
                     collevels = seq(-50, 0, 10), 
                     fastdisp = TRUE, 
                     main = 'Spectrogram of full seqence')
    dev.off()
  })
  return(tf)
}