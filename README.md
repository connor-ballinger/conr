
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Helping with Health Economics

<!-- badges: start -->
<!-- badges: end -->

conr is a package to provide templates and convenience functions for
work in health economics. It is my first package and will be bug-ridden.

## Templates

A project template exists. It provides a folder structure and
facilitates `Git` and `renv` integration (all of which are optional).

There is an Rmarkdown template to produce an .html document (current or
old HMRI branding), example below, and another to produce a Word
document (.docx).

![](./inst/images/template_example_pic.PNG)

## Functions

All function files (see their code in R/):

    #>  [1] "adorn_df.R"        "bootstrap_basic.R" "calc_ind_qaly.R"  
    #>  [4] "calc_qaly.R"       "conr-package.R"    "data.R"           
    #>  [7] "decode_text.R"     "format_date.R"     "format_docx.R"    
    #> [10] "format_html.R"     "init_project.R"    "insert_heading.R" 
    #> [13] "knit_df.R"         "plot_icer.R"       "print_regrsn.R"   
    #> [16] "round_sensibly.R"  "run_scripts.R"     "set_preferences.R"
    #> [19] "wrap_flextable.R"  "write_and_date.R"

## Installation

You can install the development version of conr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("connor-ballinger/conr")
```

## Ideas to Add

- Functions to fix/improve:

  - remove print_rgrsn
  - init_project: try setting active project in addition to directory
    for console output.
  - edit run_scripts such that there is an option to use as a background
    job - see <https://docs.posit.co/ide/user/ide/guide/tools/jobs.html>

- New functions:

  - functions for decision modelling
  - create labels and data dictionary
  - 2SB with shrinkage correction (NG 2013)
  - mean & quantiles (for bootstrap output, multiple variables)
  - wrappers to simplify use of gtsummary
  - style all sorts of tables

- Another template - pdf or shiny or a multi-page html.

- Use @describeIn or @rdname?
  <https://roxygen2.r-lib.org/articles/reuse.html>

- Make data less available? No, causes issues, perhaps simpler to leave.

  - datasets will either be automatically exported if you set LazyData:
    true in your DESCRIPTION, or made available after calling data() if
    not. <https://roxygen2.r-lib.org/articles/namespace.html>

## Testing

- I have implemented very few tests thus far. Most of the functions in
  `conr` relate to files/directories or non-interactive functions
  (executed when knitting .Rmd). Such tests seem complicated - see tests
  for usethis::create_package() or workflowr::wflow_start().

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
#> │   ├── preferences
#> │   │   └── rstudio-prefs.json
#> │   ├── rmarkdown
#> │   │   └── templates
#> │   │       ├── html-template
#> │   │       │   ├── favicon.ico
#> │   │       │   ├── hmri-logo.png
#> │   │       │   ├── skeleton
#> │   │       │   │   └── skeleton.Rmd
#> │   │       │   ├── styles.css
#> │   │       │   └── template.yaml
#> │   │       ├── html-template-deprecated
#> │   │       │   ├── skeleton
#> │   │       │   │   └── skeleton.Rmd
#> │   │       │   ├── styles-deprecated.css
#> │   │       │   └── template.yaml
#> │   │       └── word-docx-template
#> │   │           ├── skeleton
#> │   │           │   └── skeleton.Rmd
#> │   │           ├── template-conr.docx
#> │   │           └── template.yaml
#> │   └── rstudio
#> │       ├── addins.dcf
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
#> │   ├── conr-package.Rd
#> │   ├── decode_text.Rd
#> │   ├── fake_health_ec_data.Rd
#> │   ├── fn_calc_increment.Rd
#> │   ├── format_date.Rd
#> │   ├── format_docx.Rd
#> │   ├── format_html.Rd
#> │   ├── init_project.Rd
#> │   ├── insert_heading.Rd
#> │   ├── keep_prefs.Rd
#> │   ├── keep_prof.Rd
#> │   ├── knit_df.Rd
#> │   ├── knit_docx_df.Rd
#> │   ├── knit_html_df.Rd
#> │   ├── overwrite_preferences.Rd
#> │   ├── overwrite_profile.Rd
#> │   ├── plot_icer.Rd
#> │   ├── print_regrsn.Rd
#> │   ├── round_sensibly.Rd
#> │   ├── run_scripts.Rd
#> │   └── write_and_date.Rd
#> ├── NAMESPACE
#> ├── output
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
#> │   ├── insert_heading.R
#> │   ├── knit_df.R
#> │   ├── plot_icer.R
#> │   ├── print_regrsn.R
#> │   ├── round_sensibly.R
#> │   ├── run_scripts.R
#> │   ├── set_preferences.R
#> │   ├── wrap_flextable.R
#> │   └── write_and_date.R
#> ├── README.md
#> ├── README.Rmd
#> └── tests
#>     ├── testthat
#>     │   └── test-decode_text.R
#>     └── testthat.R
```
