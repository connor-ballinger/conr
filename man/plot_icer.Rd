% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_icer.R
\name{plot_icer}
\alias{plot_icer}
\title{Produce ICER Scatterplot}
\usage{
plot_icer(
  df,
  effect = "effect",
  cost = "cost",
  est_effect,
  est_cost,
  wtp,
  est_fill = "green",
  est_colour = "black",
  est_size = 2,
  est_shape = 21,
  data_alpha = 0.5,
  wtp_line_colour = "grey",
  wtp_fill = "grey",
  wtp_alpha = 0.1,
  ellipse = TRUE,
  ellipse_fill = "grey",
  ellipse_alpha = 0.2,
  zoom_factor = 4
)
}
\arguments{
\item{df}{A dataframe, likely produced from boot.}

\item{effect}{Effect column. Numeric.}

\item{cost}{Cost column. Numeric.}

\item{est_effect}{Point estimate. Numeric.}

\item{est_cost}{Point estimate. Numeric.}

\item{wtp}{WTP per unit of effect. Numeric.}

\item{est_fill}{Colour to fill point estimate. Character.}

\item{est_colour}{Colour to outline point estimate. Character.}

\item{est_size}{Size of point estimate.}

\item{est_shape}{Point type of point estimate.}

\item{data_alpha}{Point estimate transparency for data, via
geom_point(..., alpha = est_alpha). Numeric.}

\item{wtp_line_colour}{Colour of WTP line. Character.}

\item{wtp_fill}{Colour to fill beyond WTP line. Character.}

\item{wtp_alpha}{Numeric.}

\item{ellipse}{Draw ellipse? TRUE/FALSE.}

\item{ellipse_fill}{Colour of fill of ellipse. Character.}

\item{ellipse_alpha}{Transparency of ellipse. Numeric.}

\item{zoom_factor}{Change how zoomed-in the plot is using
ggplot2::coord_cartesian indirectly. Numeric.}
}
\value{
ggplot
}
\description{
Plot an ICER using \code{boot::boot} output. Most arguments optional.
Better formatting is implemented if the \code{scales} package is installed.
}
\examples{
c <- rnorm(n = 100, mean = 10000, sd = 20000) # cost
e <- rnorm(100, 3, 3) # effect
df <- data.frame(c, e)
plot_icer(df, e, c, zoom_factor = 5)
plot_icer(df, e, c, est_effect = 3, est_cost = 10000, wtp = 30000)
}
