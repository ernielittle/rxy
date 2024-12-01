#' Print method for ryx objects
#'
#' Prints a table of correlation results for the dependent variable and each independent variable.
#'
#' @param x An object of class `ryx`, containing the correlation results from the `ryx` function.
#'
#' @details This method provides a concise table of correlations, p-values, and significance levels
#' between the dependent variable (`y`) and the independent variables (`x`).
#'
#' @examples
#' library(MASS)
#' result <- ryx(Boston, y = "medv")
#' print(result)
#'
#' @export
print.ryx <- function(x, ...) {
  cat("Correlations of", x$y, "with\n")
  print(x$df, row.names = FALSE)
}

#' Plot method for ryx objects
#'
#' Creates a plot of the absolute correlations between the dependent variable and the independent variables.
#'
#' @param x An object of class `ryx`, containing the correlation results from the `ryx` function.
#'
#' @details The plot displays absolute correlation values, color-coded to indicate whether
#' the correlation is positive or negative. Positive correlations are shown in blue, and
#' negative correlations are shown in red. Independent variables are ordered by the magnitude
#' of their correlation with the dependent variable.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_segment scale_x_continuous scale_color_manual theme_minimal labs
#'
#' @examples
#' library(MASS)
#' result <- ryx(Boston, y = "medv")
#' plot(result)
#'
#' @export
plot.ryx <- function(x, ...) {
  library(ggplot2)
  
  # Add a column for direction (positive/negative) for color coding
  x$df$direction <- ifelse(x$df$r > 0, "positive", "negative")
  x$df$abs_r <- abs(x$df$r) # Absolute correlation for ordering
  
  # Create the plot
  ggplot(x$df, aes(x = abs_r, y = reorder(variable, abs_r), color = direction)) +
    geom_segment(aes(x = 0, xend = abs_r, y = reorder(variable, abs_r), yend = variable),
                 linetype = "solid", color = "grey", linewidth = 0.5) +
    geom_point(size = 3) +
    scale_color_manual(values = c("positive" = "blue", "negative" = "red")) +
    scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1)) +
    labs(title = paste("Correlations with", x$y),
         x = "Correlation (absolute value)",
         y = "Variables") +
    theme_minimal() +
    theme(legend.position = "right")
}

#' Summary method for ryx objects
#'
#' Provides a textual summary of the correlations, including the median absolute correlation and the range.
#'
#' @param object An object of class `ryx`, containing the correlation results from the `ryx` function.
#'
#' @details The summary includes the median absolute correlation, the range of correlation values,
#' and the number of significant correlations at the p < 0.05 level.
#'
#' @examples
#' library(MASS)
#' result <- ryx(Boston, y = "medv")
#' summary(result)
#'
#' @export
summary.ryx <- function(object, ...) {
  median_corr <- median(abs(object$df$r))
  cat("Correlating", object$y, "with", paste(object$x, collapse = " "), "\n")
  cat("The median absolute correlation was", round(median_corr, 3),
      "with a range from", round(min(object$df$r), 3),
      "to", round(max(object$df$r), 3), "\n")
  cat(nrow(object$df), "out of", length(object$x),
      "variables were significant at the p < 0.05 level.\n")
}
