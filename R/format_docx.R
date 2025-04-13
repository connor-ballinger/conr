#' Produce a Word Document
#'
#' @description
#' Provides a reference document with styles.
#'
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Supply any arguments to
#'   \code{\link[officedown]{rdocx_document}}. This allows arguments to be
#'   supplied in the YAML in the same way as with any standard format, just
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
    "rmarkdown/templates/word-docx-template/template-conr.docx",
    package = "conr"
  )
  arguments <- rlang::dots_list(
    reference_docx = style_ref,
    tables = list(
      topcaption = TRUE,
      tab.lp = "Table:",
      caption = list(style = "Caption")
    ),
    plots = list(
      align = "center",
      topcaption = FALSE,
      fig.lp = "Figure:",
      caption = list(style = "Caption")
    ),
    ...,
    .homonyms = "last" # means the dots will overwrite defaults
  )
  do.call(officedown::rdocx_document, arguments)
}

# default:
# page_size:
#   width: 8.3
#   height: 11.7
#   orient: "portrait"
# which is the same as A4 but the default was letter size, not A4...?
# Does the template overwrite these settings?
