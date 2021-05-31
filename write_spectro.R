write_spectro <- function(file){
  wav <- bioacoustics::read_audio(file)
  
  tf <- tempfile(fileext = '.png')
  suppressMessages({
    png(filename = tf, width = 2048, height = 2048*0.75)
    seewave::spectro(wav,
                     flim = c(10,100),
                     collevels = seq(-60, 0, 10), )
    dev.off()
  })
  return(tf)
}