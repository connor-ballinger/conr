
<!-- README.md is generated from README.Rmd. Please edit that file -->

# conr: Helping with Health Economics

<!-- badges: start -->
<!-- badges: end -->

conr is a package to provide templates and convenience functions for
work in health economics. It is my first package and will be bug-ridden.

## Templates

To this point, there is an Rmarkdown template to produce an html
document, example below.

![](./drafts/template_example_pic.PNG)

## Functions

Random bits of code that may be useful.

All functions (see their code in R/):

    #>  [1] "adorn_df.R"                      "bootstrap_basic.R"              
    #>  [3] "bootstrap_two_stage_shrinkage.R" "calc_ind_qaly.R"                
    #>  [5] "calc_qaly.R"                     "data.R"                         
    #>  [7] "decode_text.R"                   "fix_excel_cols.R"               
    #>  [9] "format_date.R"                   "format_html.R"                  
    #> [11] "knit_df.R"                       "plot_icer.R"                    
    #> [13] "print_regrsn.R"                  "round_sensibly.R"               
    #> [15] "write_and_date.R"

## Installation

You can install the development version of conr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("connor-ballinger/conr")
```

## Ideas to Add

- Functions to fix/improve:

  - 

- New functions:

  - functions for decision modelling
  - create labels and data dictionary
  - basic bootstrap
  - 2SB with shrinkage correction (NG 2013)
  - mean & quantiles (for bootstrap output, multiple variables)

- Another template - word or pdf or shiny or a multi-page html.
