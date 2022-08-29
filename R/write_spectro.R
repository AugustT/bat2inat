#' @export
write_spectro <-
function(file, TD = NULL, samp_freq = 256000, tempDir = tempdir(), verbose = TRUE){

  if(verbose) cat('Creating spectrogram')
  tf1 <- tempfile(fileext = '.png', tmpdir = tempDir)
  suppressMessages({
    png(filename = tf1, width = 8, height = 8*0.75, units = 'in', res = 300)
      fft_data <- av::read_audio_fft(file, window = av::hanning(2048), overlap = 0.2)
      av_plot(fft_data, 
              hline = seq(10, 120, 10),
              yaxp = c(0,120,12),
              legend = 'Full sequence',
              ylim = c(0,120))
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
        png(filename = tf2, width = 8, height = 8*0.75, units = 'in', res = 300)
        fft_data <- av::read_audio_fft(file,
                                       window = av::hanning(512),
                                       overlap = 0.5, 
                                       start_time = bins[1], end_time = bins[1]+bin_window)
        av_plot(fft_data,
                hline = seq(10, 120, 10),
                yaxp = c(0,120,12), 
                legend = 'Part sequence')
        dev.off()
      })
      fnames <- c(tf2, fnames)  
    }
  }
  
  if(!is.null(TD$filtered_calls_image)){
    fnames <- c(fnames, TD$filtered_calls_image)
  }
  
  if(verbose) cat('\t\tDone\n')
  return(fnames)
}
