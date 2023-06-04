
<!-- README.md is generated from README.Rmd. Please edit that file -->

# conr: Helping with Health Economics

<!-- badges: start -->
<!-- badges: end -->

conr is a package to provide templates and convenience functions for
work in health economics. It is my first package and will be buggy as
fuck.

## Templates

To this point, there is an Rmarkdown template to produce an html
document, example below.

![](./drafts/template_example_pic.png)

## Functions

There is no common theme for the functions, they are random bits of code
that may be useful.

All functions (see their code in R/):

    #>  [1] "adorn_df.R"              "calc_qaly.R"            
    #>  [3] "decode_text.R"           "fix_excel_cols.R"       
    #>  [5] "format_date.R"           "format_html.R"          
    #>  [7] "knit_print.data.frame.R" "plot_icer.R"            
    #>  [9] "print_regrsn.R"          "write_and_date.R"

The following functions are only to be used in rendering an Rmd
document:

- [format_html](./R/format_html.R)

- [knit_print.data.frame](./R/knit_print.data.frame.R)

- [write_and_date](./R/write_and_date.R)

## Installation

You can install the development version of conr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("connor-ballinger/conr")
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
