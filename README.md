
<!-- README.md is generated from README.Rmd. Please edit that file -->

# conr: Helping with Health Economics

<!-- badges: start -->
<!-- badges: end -->

conr is a package to provide templates and convenience functions for
work in health economics. It is my first package and will be bug-ridden.

## Templates

To this point, there is an Rmarkdown template to produce an html
document, example below.

![](./inst/images/template_example_pic.PNG)

## Functions

Random bits of code that may be useful.

All functions (see their code in R/):

    #>  [1] "adorn_df.R"        "bootstrap_basic.R" "calc_ind_qaly.R"  
    #>  [4] "calc_qaly.R"       "conr-package.R"    "data.R"           
    #>  [7] "decode_text.R"     "format_date.R"     "format_docx.R"    
    #> [10] "format_html.R"     "init_project.R"    "knit_df.R"        
    #> [13] "plot_icer.R"       "print_regrsn.R"    "round_sensibly.R" 
    #> [16] "write_and_date.R"

## Installation

You can install the development version of conr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("connor-ballinger/conr")
```

## Ideas to Add

- Functions to fix/improve:

  - print_regn

- New functions:

  - functions for decision modelling
  - create labels and data dictionary
  - 2SB with shrinkage correction (NG 2013)
  - mean & quantiles (for bootstrap output, multiple variables)
  - wrappers to simplify use of gtsummary
  - style all sorts of tables
  - source files up to a specific number (e.g. “05\_”)

- Another template - word or pdf or shiny or a multi-page html.

## Package Overview

``` r
fs::dir_tree()
#> .
#> ├── conr.Rproj
#> ├── data
#> │   └── fake_health_ec_data.rda
#> ├── data-raw
#> │   └── fake_health_ec_data.R
#> ├── DESCRIPTION
#> ├── inst
#> │   ├── images
#> │   │   └── template_example_pic.PNG
#> │   ├── rmarkdown
#> │   │   └── templates
#> │   │       ├── output_styling_only
#> │   │       │   ├── skeleton
#> │   │       │   │   ├── styles.css
#> │   │       │   │   └── template-conr.docx
#> │   │       │   └── template.yaml
#> │   │       ├── rmd_template
#> │   │       │   ├── skeleton
#> │   │       │   │   └── skeleton.Rmd
#> │   │       │   └── template.yaml
#> │   │       └── word_docx_template
#> │   │           ├── skeleton
#> │   │           │   └── skeleton.Rmd
#> │   │           └── template.yaml
#> │   └── rstudio
#> │       └── templates
#> │           └── project
#> │               └── proj_template.dcf
#> ├── LICENSE
#> ├── LICENSE.md
#> ├── man
#> │   ├── adorn_df.Rd
#> │   ├── bootstrap_basic.Rd
#> │   ├── calc_ind_qaly.Rd
#> │   ├── calc_qaly.Rd
#> │   ├── decode_text.Rd
#> │   ├── fake_health_ec_data.Rd
#> │   ├── fix_excel_cols.Rd
#> │   ├── format_date.Rd
#> │   ├── format_html.Rd
#> │   ├── init_project.Rd
#> │   ├── knit_df.Rd
#> │   ├── knit_docx_df.Rd
#> │   ├── knit_html_df.Rd
#> │   ├── plot_icer.Rd
#> │   ├── print_regrsn.Rd
#> │   ├── round_sensibly.Rd
#> │   └── write_and_date.Rd
#> ├── NAMESPACE
#> ├── R
#> │   ├── adorn_df.R
#> │   ├── bootstrap_basic.R
#> │   ├── calc_ind_qaly.R
#> │   ├── calc_qaly.R
#> │   ├── conr-package.R
#> │   ├── data.R
#> │   ├── decode_text.R
#> │   ├── format_date.R
#> │   ├── format_docx.R
#> │   ├── format_html.R
#> │   ├── init_project.R
#> │   ├── knit_df.R
#> │   ├── plot_icer.R
#> │   ├── print_regrsn.R
#> │   ├── round_sensibly.R
#> │   └── write_and_date.R
#> ├── README.md
#> └── README.Rmd
```
