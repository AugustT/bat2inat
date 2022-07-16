#' @export
write_spectro <-
function(file, TD = NULL, samp_freq = 256000, tempDir = tempdir(), verbose = TRUE){

  if(verbose) cat('Creating spectrogram')
  tf1 <- tempfile(fileext = '.png', tmpdir = tempDir)
  suppressMessages({
    png(filename = tf1, width = 1024, height = 1024*0.75)
      fft_data <- av::read_audio_fft(file, window = av::hanning(2048), overlap = 0.2)
      plot(fft_data,
           main = 'Spectrogram of full sequence')
    dev.off()
    fnames <- tf1
  })
  
  if(!is.null(TD)){
    
    if(!is.null(TD$call_start)){
      
      s <- TD$call_start / samp_freq
      e <- TD$call_end / samp_freq
      
      bin_window <- 0.5
      
      bins <- sort(table(floor(s/bin_window)*bin_window), decreasing = TRUE)
      bins <- as.numeric(names(bins))
      
      tf2 <- tempfile(fileext = '.png', tmpdir = tempDir)
      suppressMessages({
        png(filename = tf2, width = 1024, height = 1024*0.75)
        fft_data <- av::read_audio_fft(file,
                                       window = av::hanning(512),
                                       overlap = 0.5, 
                                       start_time = bins[1], end_time = bins[1]+bin_window)
        plot(fft_data,
             main = 'Part sequence')
        dev.off()
      })
      plot(fft_data,
           main = 'Part sequence')
      fnames <- c(tf2, fnames)  
    }
  }
  
  if(!is.null(TD$filtered_calls_image)){
    fnames <- c(fnames, TD$filtered_calls_image)
  }
  
  if(verbose) cat('\t\tDone\n')
  return(fnames)
}
