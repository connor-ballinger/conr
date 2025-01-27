#' Knit nice dataframes in .docx and .html
#'
#' @description Redefine the default print method for objects with class
#'   `data.frame` when the rmarkdown file is knitted. If the file is knitted to
#'   html, then `data.frame` objects will be output as
#'   \code{\link[DT]{datatable}}. Knitting to Word (.docx) produces a
#'   \code{\link[flextable]{flextable}}.
#'
#'   For further info, see \code{\link[knitr]{knit_print}} and
#'   \code{\link[base]{.S3method}} and
#'   \url{https://github.com/rstudio/rmarkdown-cookbook/issues/186}.
#'
#'   If you need to modify the method, define `knit_print.data.frame` in the
#'   document. I tried to create two functions, such that I could pass arguments
#'   to the knitting fn (changing `DT_opts`) but it seems too difficult.
#'
#'   Why `DT` over `gt`? `DT`: pages, choose pageLength, copy/csv buttons. `gt`:
#'   has most of this here
#'   \url{https://gt.rstudio.com/reference/opt_interactive.html}, but not the
#'   download option.
#'
#'   \code{reactable} is another alternative to \code{\link[DT]{datatable}}.
#'
#'   Currently not ideal as \code{\link[DT]{datatable}} trims trailing zeros,
#'   leading to inconsistent number of decimal places in a given column.
#'   \code{\link[DT]{formatRound}} is not an option as trailing zeros are never
#'   trimmed.
#'
#' @param ... Usual dots.
#'
#' @importFrom knitr pandoc_to
#'
#' @return \code{\link[base]{.S3method}}.
#' @seealso [knit_docx_df()], [knit_html_df()]
#' @export
#'
#' @examples
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
#' @return Returns the dataframe in the form of
#'   \code{\link[flextable]{flextable}}, via `knitr::knit_print`.
#' @seealso [knit_df()], [knit_html_df()]
#' @export
#'
#' @importFrom knitr knit_print
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr where
#' @importFrom flextable flextable
#' @importFrom flextable nrow_part
#' @importFrom flextable bg
#' @importFrom sjlabelled label_to_colnames
#'
#' @examples
knit_docx_df <- function(df, ...) {
  df <- df |>
    dplyr::mutate(
      dplyr::across(
        .cols = where(~ is.numeric(.x) & !is(.x, "Timespan")),
        .fns = ~ conr::round_sensibly(.x, 4)
      )
    ) |>
    sjlabelled::label_to_colnames()
  table <- flextable::flextable(df) |>
    flextable::autofit()
  if (flextable::nrow_part(table) >= 2) {
    table <- flextable::bg(
      table,
      bg = "grey97",
      i = seq.int(from = 2, to = flextable::nrow_part(table), by = 2)
    )
  }
  knitr::knit_print(table, ...)
}

#' Knit method for dataframes in html output
#'
#' @param df dataframe
#' @param DT_opts passed to DT
#' @param ... dots
#'
#' @return Returns the dataframe in the form of \code{\link[DT]{datatable}}, via
#'   `knitr::knit_print`.
#' @seealso [knit_df()], [knit_docx_df()]
#' @export
#'
#' @importFrom knitr knit_print
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr where
#' @importFrom DT datatable
#' @importFrom sjlabelled label_to_colnames
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
      buttons = c("copy", "csv")
    ),
    ...) {
  df <- df |>
    dplyr::mutate(
      dplyr::across(
        .cols = where(~ is.numeric(.x) & !is(.x, "Timespan")),
        .fns = ~ conr::round_sensibly(.x, 4)
      )
    ) |> sjlabelled::label_to_colnames()
  knitr::knit_print(DT::datatable(df, DT_opts, extensions = "Buttons"), ...)
}
