% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/decode_text.R
\name{decode_text}
\alias{decode_text}
\title{Decode Text for Aesthetics}
\usage{
decode_text(x)
}
\arguments{
\item{x}{A character vector.}
}
\value{
A visually-appealing character vector.
}
\description{
Transform text which is used for code to something more
normal-looking. Underscores replaced with spaces, title case, periods
replaced with spaces, "x" preceding numbers removed (e.g. x2025).
}
\examples{
colnames(iris)
decode_text(colnames(iris))
colnames(fake_health_ec_data)
colnames(fake_health_ec_data) |> decode_text()
}
