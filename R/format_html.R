#' Produce an HTML Report
#'
#' @description
#' Produce an .html file from .Rmd, with branding and some preferences.
#'
#' @return `rmarkdown::html_document`
#' @export
#'
#' @examples
format_html <- function() {
  styles <- system.file(
    "rmarkdown/templates/output_styling_only/skeleton/styles.css",
    package = "conr"
  )

  rmarkdown::html_document(
    theme = "default",
    toc = TRUE,
    toc_float = TRUE,
    number_sections = TRUE,
    css = styles,
    out.width = "830px",
    code_folding = "hide",
  )
}
