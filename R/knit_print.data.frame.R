#' Define a Dataframe Knitting Function
#'
#' @param df The dataframes which will be parsed from knit_df().
#' @param DT_opts The options from knit_df().
#' @param ...
#'
#' @return DT table.
#' @export
#'
#' @description Redefine the default print method for objects with class
#'   "data.frame". For further info:
#'   https://github.com/rstudio/rmarkdown-cookbook/issues/186. If you need to
#'   modify the method, define knit_print.data.frame in the document, and remove
#'   the conr:: prefix. I tried to create two functions, such that I could pass
#'   arguments to the knitting fn (changing DT_opts) but it seems too difficult.
#'
#'   Why DT over gt? DT: pages, choose pageLength, copy/csv buttons. gt: has
#'   most of this here https://gt.rstudio.com/reference/opt_interactive.html,
#'   but not the download option.
#'
#'   Not sure why this changed from a function exported from conr to a method
#'   which always automatically overwrites the default rmarkdown method, without
#'   any need for calling function.
#'
#'   Currently not ideal as datatable() trims trailing zeros, leading to
#'   inconsistent number of decimal places in a given column. DT::formatRound is
#'   not an option as trailing zeros are never trimmed.
#'
#' @importFrom DT datatable
#' @import knitr
#'
#' @examples
#'
knit_print.data.frame <- function(

  df,
  DT_opts = list(
    rownames = TRUE,
    dom = "ltipB",
    filter = "top",
    scrollX = TRUE,
    pageLength = 5,
    lengthMenu = c(5, 10, 20),
    buttons = c('copy', 'csv')
  ),

  ...) {

  df = df |>
    mutate(across(where(is.numeric), ~ conr::round_sensibly(.x, 4)))

  knitr::knit_print(DT::datatable(df, DT_opts, extensions = "Buttons"))

}
