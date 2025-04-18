% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adorn_df.R
\name{adorn_df}
\alias{adorn_df}
\title{Adorn a dataframe with percent and '000s separator}
\usage{
adorn_df(df, perc_accuracy = 1, num_accuracy = 0.01, ...)
}
\arguments{
\item{df}{A dataframe (tibble expected).}

\item{perc_accuracy}{A number, like in \code{\link[base]{format}(accuracy =
_)}, for percentage columns. Default is 1 - round to zero decimal places.}

\item{num_accuracy}{A number like perc_digits, but for numeric columns.
Default is 0.01 - round to two decimal places.}

\item{...}{Dots.}
}
\value{
A dataframe.
}
\description{
Make your dataframe presentable by: renaming columns, adding
comma separator, transforming columns to percent.
}
\examples{
df <- data.frame(
  a_col = rnorm(5) * 1e6,
  portion = rnorm(5),
  Growth = rnorm(5),
  growth2 = 0.025
)
df
adorn_df(df)
}
