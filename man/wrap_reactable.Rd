% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wrap_reactable.R
\name{wrap_reactable}
\alias{wrap_reactable}
\title{Reactable table wrapper}
\usage{
wrap_reactable(
  df,
  ...,
  downloadable = !interactive(),
  filename = "data.csv",
  table_id = NULL
)
}
\arguments{
\item{df}{Dataframe.}

\item{...}{<\code{\link[rlang:dyn-dots]{dynamic-dots}}> Supply any arguments to
\code{\link[reactable]{reactable}}. This allows any of the defaults to be
changed.}

\item{downloadable}{TRUE/FALSE - should a download button be provided for
this table?}

\item{filename}{Name of the csv file which can be downloaded from the table.}

\item{table_id}{Unique table identifier, required for the download option. By
default, a random string is produced.}
}
\description{
This function is intended to simplify printing of tables from .Rmd or .qmd
into HTML format. See \code{\link[reactable]{reactable}} documentation.
}
\details{
The following arguments of \code{\link[reactable]{reactable}} have been
specified, but they can be changed by supplying arguments to the dots.

\if{html}{\out{<div class="sourceCode">}}\preformatted{filterable = FALSE,
searchable = TRUE,
defaultPageSize = 5,
showPageSizeOptions = TRUE,
pageSizeOptions = c(5, 10, 25),
paginationType = "simple",
highlight = TRUE,
compact = TRUE,
wrap = FALSE,
showSortIcon = TRUE,
showSortable = TRUE,
fullWidth = TRUE,
language = reactable::reactableLang(
  pagePrevious = "\\u276e",
  pageNext = "\\u276f",
  pagePreviousLabel = "Previous page", # accessible labels
  pageNextLabel = "Next page"
),
theme = reactable::reactableTheme(
  style = list(
    fontFamily = "Roboto, Helvetica, Arial",
    searchInputStyle = list(width = "200px", fontSize = "12px")
  )
)
}\if{html}{\out{</div>}}
}
\examples{
wrap_reactable(penguins)
wrap_reactable(
  penguins, filename = "penguins.csv", table_id = "penguins",
  compact = FALSE, outlined  = TRUE
)
# Formatting columns preserves the underlying data but changes the display.
# Formatting can be applied to a subset of columns and the other columns will
# still print.
wrap_reactable(
  penguins,
  downloadable = FALSE,
  columns = list(
    bill_len = reactable::colDef(
      format = reactable::colFormat(
        prefix = "$",
        separators = TRUE,
        digits = 2
      )
    ),
    bill_dep = reactable::colDef(
      format = reactable::colFormat(percent = TRUE, digits = 0)
    )
  )
)
\dontshow{if (requireNamespace("labelled") & requireNamespace("stringr")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
library(labelled)
library(stringr)
# Anchor a column. Pretend you already have labelled variables and want the
# labels to be printed.
penguins <- penguins |>
  labelled::set_variable_labels(
    .labels = stringr::str_to_title(colnames(penguins))
  )
# reactable does not automatically display labels... is there a better way to
# make them appear?
colnames(penguins) <- unlist(labelled::var_label(penguins))
penguins |>
  wrap_reactable(
    columns = list(
      Species = reactable::colDef(
        sticky = "left",
        # Add a right border style to visually distinguish the sticky column
        style = list(borderRight = "1px solid #eee"),
        headerStyle = list(borderRight = "1px solid #eee")
      )
    ),
    width = 400 # limit width just to demonstrate the anchored column
  )
\dontshow{\}) # examplesIf}
}
