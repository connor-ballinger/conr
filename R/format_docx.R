#' Produce a Word Document
#'
#' @description
#' Provides a reference document with styles.
#'
#' @return `officedown::rdocx_document` to pass to `rmarkdown::render`.
#' @export
#'
#' @importFrom officedown rdocx_document
#'
#' @examples
format_docx <- function() {
  style_ref <- system.file(
    "rmarkdown/templates/output_styling_only/skeleton/template-conr.docx",
    package = "conr"
  )
  officedown::rdocx_document(reference_docx = style_ref)
}
