#' Adorn a dataframe with percent and '000s separator
#'
#' @description Make your dataframe presentable by: renaming columns, adding
#'   comma separator, transforming columns to percent.
#'
#' @param df A dataframe (tibble expected).
#' @param perc_digits Integer. Default is 0 - round to zero decimal places.
#' @param num_digits A number like perc_digits, but for numeric columns.
#'   Default is 2 - round to two decimal places.
#' @param ... Dots.
#'
#' @return A dataframe.
#' @export
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr where
#' @importFrom dplyr rename_with
#' @importFrom dplyr contains
#'
# @importFrom scales label_percent
# @importFrom scales label_comma
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
adorn_df <- function(df, perc_digits = 0, num_digits = 2, ...) {
  df |>
    dplyr::mutate(
      dplyr::across(
        dplyr::where(is.numeric) & # integers may need to be changed: 1 -> 100%
          (dplyr::contains("portion") | dplyr::contains("growth")),
        ~ round_sensibly(.x * 100, digits = perc_digits) |>
          format(big.mark = ",", format = "fg", scientific = FALSE) |>
          paste0("%")
        # ~ scales::label_percent(accuracy = perc_accuracy)(
        #   conr::round_sensibly(.x, digits = -log10(perc_accuracy / 100))
        # )
      ),
      dplyr::across(
        dplyr::where(is.numeric), # integers may need to be changed: 11 -> 10
        ~ round_sensibly(.x, digits = num_digits) |>
          format(big.mark = ",", format = "fg", scientific = FALSE)
        # ~ scales::label_comma(accuracy = num_accuracy)(
        #   conr::round_sensibly(.x, digits = -log10(num_accuracy))
        # )
      )
    ) |>
    dplyr::rename_with(conr::decode_text)
}
