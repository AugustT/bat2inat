av_plot <- function (x, y, dark = TRUE, legend = '', keep.par = FALSE, 
          useRaster = TRUE, vline = FALSE, hline = NULL, ylim = c(0,120), ...) 
{
  if (!isTRUE(keep.par)) {
    oldpar <- par(no.readonly = TRUE)
    on.exit(par(oldpar))
  }
  col <- if (isTRUE(dark)) {
    par(bg = "black", col.axis = "white", fg = "white", 
        family = "mono", font = 2, col.lab = "white", 
        col.main = "white")
    c("#FCFFA4FF", "#F5DB4BFF", "#FCAD12FF", 
      "#F78311FF", "#E65D2FFF", "#CB4149FF", 
      "#A92E5EFF", "#85216BFF", "#60136EFF", 
      "#3A0963FF", "#140B35FF", "#000004FF")
  }
  else {
    c("#FFFFC8", "#FFF4B7", "#FBE49A", 
      "#F8D074", "#F7BA3C", "#F5A100", 
      "#F28400", "#ED6200", "#E13C00", 
      "#C32200", "#A20706", "#7D0025")
  }
  par(mar = c(5, 5, 3, 3), mex = 0.6)
  image(attr(x, "time"), attr(x, "frequency")/1000, 
        t(x), xlab = "TIME", ylab = "FREQUENCY (kHZ)",
        ylim = ylim, 
        col = col, useRaster = useRaster, ...)
  if (legend!='') {
    legend("topright", legend = legend, pch = "", 
           xjust = 1, yjust = 1, bty = "o", cex = 0.7)
  }
  if (length(vline)) {
    abline(v = vline, lwd = 2)
  }
  if (!is.null(hline)){
    for(i in hline){
      abline(h = i, col = rgb(1,1,1,0.3, maxColorValue = 1))
    }
  }
}