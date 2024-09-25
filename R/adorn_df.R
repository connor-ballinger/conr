#' Adorn a Dataframe with Percent and '000s Separator
#'
#' @description
#' Make your dataframe presentable by: renaming columns, adding comma separator,
#' transforming columns to percent.
#'
#' @param df A dataframe (tibble expected).
#' @param perc_accuracy A number, like in format(accuracy = _), for percentage
#'   columns. 0.01 means to two decimal places.
#' @param num_accuracy A number like perc_digits, but for numeric columns.
#' @param ... Dots.
#'
#' @return A dataframe.
#' @export
#'
#' @importFrom scales label_percent
#' @importFrom scales label_comma
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr where
#' @importFrom dplyr rename_with
#' @importFrom dplyr contains
#'
#' @examples
#' df <- data.frame(
#'   a_col = rnorm(5) * 1e6,
#'   portion = rnorm(5),
#'   Growth = rnorm(5),
#'   growth2 = 0.025
#' )
#' df
#' adorn_df(df)
adorn_df <- function(df, perc_accuracy = 1, num_accuracy = .01, ...) {
  dplyr::mutate(
    df,
    dplyr::across(
      dplyr::where(is.double) & # leave integers alone
        (dplyr::contains("portion") | dplyr::contains("growth")),
      ~ scales::label_percent(accuracy = perc_accuracy)(
        conr::round_sensibly(.x, digits = -log10(perc_accuracy / 100))
      )
    ),
    dplyr::across(
      dplyr::where(is.double), # leave integers alone
      ~ scales::label_comma(accuracy = num_accuracy)(
        conr::round_sensibly(.x, digits = -log10(num_accuracy))
      )
    )
  ) |>
    dplyr::rename_with(conr::decode_text)
}
