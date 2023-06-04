#' Adorn a Dataframe with Percent and '000s Separator
#'
#' @param df A dataframe (tibble expected).
#' @param perc_digits A number, like in format(accuracy = _), for percentage
#'   columns.
#' @param digits A number like perc_digits, but for numeric columns.
#' @param ...
#'
#' @return A dataframe.
#' @export
#'
#' @examples
adorn_df <- function(df, perc_digits = 1, digits = 1, ...) {
  # heavily relies on dplyr

  dplyr::mutate(df, across(where(is.numeric) &
                             (contains("portion") | contains("growth")),
                           scales::label_percent(accuracy = perc_digits)),
                across(where(is.numeric),
                       ~ format(., big.mark = ",", digits = digits))) |>
    dplyr::rename_with(conr::decode_text)
}




