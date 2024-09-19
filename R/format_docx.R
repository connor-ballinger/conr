#' Produce a Word Document
#'
#' @description
#' Provides a reference document with styles.
#'
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Supply any arguments to
#'   \code{\link[officedown]{rdocx_document}}. This allows arguments to be
#'   supplied in the YAML in the same was as with any standard format, just
#'   remember to use spaces to indent, not tabs.
#'
#' @return `officedown::rdocx_document` to pass to `rmarkdown::render`.
#' @export
#'
#' @importFrom officedown rdocx_document
#' @importFrom rlang dots_list
#'
#' @examples
format_docx <- function(...) {
  style_ref <- system.file(
    "rmarkdown/templates/output_styling_only/skeleton/template-conr.docx",
    package = "conr"
  )
  arguments <- rlang::dots_list(
    reference_docx = style_ref,
    ...,
    .homonyms = "last" # means the dots will overwrite defaults
  )
  do.call(officedown::rdocx_document, arguments)
}
