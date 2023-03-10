#' @export
#' @name hist_compare_to_normal
#' @title hist_compare_to_normal
#' @param x data vector to be visualized.
#' @param col color of the histogram.
#' @param main string indicating the title of the plot.
#' @param xlab a string indicating the x label.
#' @param ylab a string indicating the y label.
#' @param add_legend a Boolean if the estimated parameters of the Normal distribution should be plotted.
#' @param legend_position a string specifying the position of the legend.
#' @param lwd_line width of density lines.
#' @param col_line1 color of density line classic mle estimation.
#' @param col_line2 color of density line classic robust estimation.
#' @param delta graphic parameter to determine the shrinkage of the axis.
#' @return  No return value. Plot a histogram.
#' @param ...  Extra graphical arguments.
#' @importFrom graphics hist legend lines
#' @importFrom stats dnorm mad median sd
#' @examples
#' n <- 1000
#' x <- rnorm(n = n)
#' hist_compare_to_normal(x)
#' x2 <- rexp(n, rate = 25)
#' hist_compare_to_normal(x2, legend_position = "topright")
hist_compare_to_normal <- function(x,
                                   col = "lightgray",
                                   main = "", xlab = "",
                                   ylab = "",
                                   lwd_line = 1.5,
                                   col_line1 = "#ff160e",
                                   col_line2 = "#335bff",
                                   add_legend = TRUE,
                                   legend_position = "topleft",
                                   delta = 0.2,
                                   ...) {


  # compute min and max
  min_x <- min(x) - delta * (max(x) - min(x))
  max_x <- max(x) + delta * (max(x) - min(x))

  # estimate mean and sd
  mean_x <- mean(x)
  sd_x <- sd(x)

  # estimate median and mad
  med_x <- median(x)
  mad_x <- mad(x)

  # compute normal density
  xx <- seq(from = min_x, to = max_x, length.out = 500)
  yy1 <- dnorm(xx, mean = mean_x, sd = sd_x)
  yy2 <- dnorm(xx, mean = med_x, sd = mad_x)

  # plot histogram
  h <- hist(x, plot = FALSE)

  # get value ymax
  y_max <- max(c(h$density, yy1, yy2))

  h <- hist(x,
    col = col, main = main,
    xlab = xlab, ylab = ylab, freq = FALSE,
    xlim = c(min_x, max_x), ylim = c(0, y_max), plot = TRUE
  ) # , ...

  # add line
  lines(x = xx, y = yy1, type = "l", col = col_line1, lwd = lwd_line)
  lines(x = xx, y = yy2, type = "l", col = col_line2, lwd = lwd_line, lty = 2)


  legend_expression <- do.call(
    "expression",
    list(
      bquote(bar(x) == .(round(mean_x, 3))),
      bquote(hat(sigma) == .(round(sd_x, 3))),
      "Standard", "Robust"
    )
  )

  # add legend if add_estimated_param
  if (add_legend) {
    legend(legend_position,
      legend = legend_expression,
      bty = "n", cex = .85,
      col = c(NA, NA, col_line1, col_line2),
      lwd = c(NA, NA, lwd_line, lwd_line),
      lty = c(NA, NA, 1, 2)
    )
  }
}

#
# # test
# n = 1000
# x <- rnorm(n = n)
# hist_compare_to_normal(x)
# x2 = rexp(n, rate = 25)
# hist_compare_to_normal(x2, legend_position = "topright")
