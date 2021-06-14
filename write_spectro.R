write_spectro <- function(file, verbose = TRUE){

  if(verbose) cat('Creating spectrogram')
  tf <- tempfile(fileext = '.png')
  suppressMessages({
    png(filename = tf, width = 1024, height = 1024*0.75)
      fft_data <- av::read_audio_fft(file, window = hanning(1024), overlap = 0.5)
      plot(fft_data,
           main = 'Spectrogram of full sequence')
    dev.off()
  })
  if(verbose) cat('\t\tDone\n')
  return(tf)
}