#' Calculate QALYs for a Data Frame
#'
#' @param df Dataframe.
#' @param qol Columns which contain QALY weights.
#' @param periods Vector containing the number of weeks between each measure.
#'
#' @return df with an additional column, named qaly.
#' @export
#'
#' @import dplyr
#' @importFrom purrr modify2
#'
#' @examples
#' testdf <- data.frame(
#'   id = 1:3,
#'   u0 = c(0, 0, 1),
#'   u1 = c(0.8, 0.4, 1),
#'   u2 = c(0.9, 0.7, 1),
#'   u3 = c(0.4, 0.6, 1)
#' )
#'
#' calc_qaly(testdf, qol = c("u0", "u1", "u2", "u3"), periods = c(4, 13, 26))

calc_qaly <- function (
    df,
    qol,
    periods
) {

  multiplier = periods_to_trapezium(periods)
  scores = purrr::modify2(df[, {{ qol }}], multiplier, `*`)
  scores = scores |>
    rowwise() |>
    mutate(qaly = sum(c_across(everything())) / 104) # 52 weeks * 2 for area trapezium
  mutate(df, qaly = scores$qaly)

}


periods_to_trapezium <- function(periods) {

  additions = periods[-length(periods)] + periods[-1] # Area trapezium = h*(a+b)/2
  c(periods[1], additions, periods[length(periods)]) # This creates all a+b for trapeziums.

}
