#' Knit nice dataframes in .docx and .html
#'
#' @param ... Usual dots.
#'
#' @return Probably nothing.
#' @export
#'
#' @description Redefine the default print method for objects with class
#'   "data.frame". For further info:
#'   https://github.com/rstudio/rmarkdown-cookbook/issues/186. If you need to
#'   modify the method, define knit_print.data.frame in the document. I tried to
#'   create two functions, such that I could pass arguments to the knitting fn
#'   (changing DT_opts) but it seems too difficult.
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
#' @import knitr
#'
#' @examples
#'
knit_df <- function(...) {

  if (knitr::pandoc_to("docx")) {

    .S3method("knit_print", "data.frame", knit_docx_df)

  } else if (knitr::pandoc_to("html")) {

    .S3method("knit_print", "data.frame", knit_html_df)

  }
}

#' Knit method for dataframes in docx output
#'
#' @param df dataframe
#' @param ... dots
#'
#' @return not sure
#' @export
#'
#' @import knitr
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr where
#' @importFrom flextable flextable
#' @importFrom flextable nrow_part
#' @importFrom flextable bg
#'
#' @examples
knit_docx_df <- function(df, ...) {

  df = df |>
    mutate(across(where(is.numeric), ~ conr::round_sensibly(.x, 4)))

  table = flextable(df)

  if (nrow_part(table) >= 2) {
    table = bg(table,
               bg = "grey97",
               i = seq(from = 2, to = nrow_part(table), by = 2))
  }

  knitr::knit_print(table, ...)

}

#' Knit method for dataframes in html output
#'
#' @param df dataframe
#' @param DT_opts passed to DT
#' @param ... dots
#'
#' @return not sure
#' @export
#'
#' @import knitr
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr where
#' @importFrom DT datatable
#'
#' @examples
knit_html_df <- function(

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

  knitr::knit_print(DT::datatable(df, DT_opts, extensions = "Buttons"), ...)

}