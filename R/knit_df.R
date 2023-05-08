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
knit_print.data.frame <-
  function(df, adorn = TRUE, DT_opts = list(rownames = TRUE, dom = "tip",
                              scrollX = TRUE, pageLength = 5), ...) {
    if (adorn) {df = conr::adorn_df(df)}
    knitr::knit_print(DT::datatable(df, DT_opts))
  }

#' Knit Nice Dataframes
#'
#' @param DT_opts Options to pass to DT::datatable()
#' @param ...
#'
#' @return Silently, changes the method used to knit dataframes.
#' @export
#'
#' @examples
knit_df <- function(df, DT_opts = list(rownames = TRUE, dom = "tip",
                                       scrollX = TRUE, pageLength = 5), ...) {
  registerS3method("knit_print", "data.frame", conr::knit_print.data.frame)
}

# the advantage of the second function is that I could choose options in the
# .Rmd, if I can figure out how to pass args across fns

# redefine the default print method for objects with class "data.frame"
# see # https://github.com/rstudio/rmarkdown-cookbook/issues/186
