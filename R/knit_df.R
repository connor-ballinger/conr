#' Define a Dataframe Knitting Function
#'
#' @param df The dataframes which will be parsed from knit_df().
#' @param DT_opts The options from knit_df().
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#' # redefine the default print method for objects with class "data.frame"
#' # https://github.com/rstudio/rmarkdown-cookbook/issues/186
knit_print.data.frame <-
  function(df,
           DT_opts = list(rownames = TRUE, dom = "tip", filter = "top",
                          scrollX = TRUE, pageLength = 5,
                          initComplete = htmlwidgets::JS(
                            "function(settings, json) {",
                            paste0("$(this.api().table().container()).css({'font-size': 9pt});"),
                            "}")), ...) {
    knitr::knit_print(DT::datatable(df, DT_opts))
  }

# initComplete from https://stackoverflow.com/questions/44101055/changing-font-size-in-r-datatables-dt
# I tried to create two functions, such that I could pass arguments to the
# knitting fn (changing DT_opts) but it seems too difficult.
