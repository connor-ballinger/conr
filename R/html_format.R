#' Produce an HTML Report
#'
#' @return Not sure, essentially a html report.
#' @export
#'
#' @examples
#' output: conr::html_format

html_format <- function() {

  # locate resources
  styles = system.file("rmarkdown/templates/output_styling_only/skeleton/styles.css",
                       package = "conr")

  # format html
  rmarkdown::html_document(
    theme = "flatly",
    toc = TRUE,
    toc_float = TRUE,
    number_sections = TRUE,
    css = styles,
    code_folding = "hide",
    df_print = "paged"
  )
}
