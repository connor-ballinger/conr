#' Define a Dataframe Knitting Function
#'
#' @param df The dataframes which will be parsed from knit_df().
#' @param DT_opts The options from knit_df().
#' @param ...
#'
#' @return DT table.
#' @export
#'
#' @import dplyr
#' @importFrom DT datatable
#' @importFrom knitr knit_print
#'
#' @examples
#' # redefine the default print method for objects with class "data.frame"
#' # https://github.com/rstudio/rmarkdown-cookbook/issues/186
#' # If you need to modify the method, define knit_print.data.frame in the
#' # document, and remove the conr:: prefix in
#' # registerS3method("knit_print", "data.frame", conr::knit_print.data.frame).
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

  df |>
    mutate(across(where(is.numeric), ~ conr::round_sensibly(.x, digits = 4))) |>
    DT::datatable(options = DT_opts, extensions = "Buttons") |>
    knitr::knit_print()

  # knitr::knit_print(DT::datatable(df, extensions = "Buttons", DT_opts))

}

# initComplete from https://stackoverflow.com/questions/44101055/changing-font-size-in-r-datatables-dt
# I tried to create two functions, such that I could pass arguments to the
# knitting fn (changing DT_opts) but it seems too difficult.
