#' Produce Simple Quantile-Quantile Plots
#'
#' @param model
#'
#' @return A ggplot.
#' @export
#'
#' @examples
#' my_model <- lm(y ~ x, data)
#' qq_plot(my_model)
qq_plot <- function(model) {
  ggplot(data = as_tibble(resid(model)), aes(sample = value)) +
    stat_qq_line() +
    stat_qq()
}
