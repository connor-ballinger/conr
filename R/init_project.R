#' Initiate project
#'
#' @description Create a new project with some folder structures and preferences
#'   in place. Similar examples:
#'
#'   \url{https://rstudio.github.io/rstudio-extensions/rstudio_project_templates.html}
#'
#'   \url{https://github.com/jonas-hag/analysistemplates/}
#'
#'   \url{https://github.com/rostools/prodigenr/blob/main/R/setup_project.R}
#'
#'
#' @param path String for desired directory.
#' @param use_folders TRUE/FALSE Use the default directory structure, with some
#'   blank files.
#' @param use_git TRUE/FALSE Use Git?
#' @param use_renv TRUE/FALSE Use renv?
#' @param ... Dots.
#'
#' @return A project.
#' @export
#'
#' @importFrom cli cli_alert_info
#' @importFrom cli cli_alert_success
#' @importFrom cli cli_alert_warning
#' @importFrom dplyr filter
#' @importFrom dplyr pull
#' @importFrom fs dir_tree
#' @importFrom withr local_dir
#'
# @importFrom gert git_add
# @importFrom gert git_commit_all
# @importFrom gert git_config
# @importFrom gert git_init
# @importFrom renv init

# add github - remote?
# see source code of usethis::use_rstudio - lots of potentially useful functions.
# rstudio.R file and proj.R
# Also see workflowr pkg

init_project <- function(path, use_renv = TRUE, use_git = TRUE,
                         use_folders = TRUE, ...) { # use_packages = TRUE,

  # if (use_renv == FALSE & use_packages == TRUE) {
  #   use_packages <- FALSE
  #   cli::cli_alert_warning(
  #     "There is no need to use packages if not using {.pkg renv}."
  #   )
  # }

  if (use_renv) {
    if(!requireNamespace("renv", quietly = TRUE)) {
      stop(
        "Package 'renv' is needed for use_renv = TRUE. Please install it.",
        call. = FALSE
      )
    }
  }
  if (use_git) {
    if(!requireNamespace("gert", quietly = TRUE)) {
      stop(
        "Package 'gert' is needed for use_git = TRUE. Please install it.",
        call. = FALSE
      )
    }
  }

  # clean proj name
  if (grepl(" ", basename(path))) {
    cli::cli_alert_warning(
      "Project name has a space in it, replacing with a dash (-)."
    )
    path_base <- gsub(" ", "-", basename(path))
    path <- sub(basename(path), path_base, path)
  }

  # create directory
  dir.create(path, recursive = TRUE)
  full_path <- path.expand(path = path)
  cli::cli_alert_success("Directory {.path {full_path}} created.")

  # setwd(path)
  # wd <- getwd()

  withr::local_dir(path)
  write_proj(path = path)

  if (use_folders) {
    write_folders()
  }
  if (use_git) {
    gert::git_init()
    cli::cli_alert_success("Local Git repository created.")
  }
  if (use_renv) {
    renv::init(load = FALSE, restart = FALSE)
    cli::cli_alert_success("{.pkg renv} project library created.")
    # if (use_packages) {
    #   write_packages(path = wd)
    #   cli::cli_alert_success(
    #     "Some key packages have been added to the {.pkg renv} project library."
    #   )
    # }
  }
  file.create("README.Rmd")
  write_readme(path = path, use_git = use_git, proj_name = basename(path))
  if (use_git) {
    gert::git_add(files = ".")
    gert::git_add(files = ".gitignore") # has to be manually added
    gert::git_commit_all(message = "Initial commit")
    cli::cli_alert_success("Initial changes have been committed.")
  }
  cli::cli_alert_info("Project overview:")
  fs::dir_tree(recurse = 2)
}

write_readme <- function(path, use_git, proj_name, ...) {
  # some parameters first
  author <- if (use_git) {
    gert::git_config() |>
      dplyr::filter(.data$name == "user.name") |>
      dplyr::pull(.data$value)
  } else {
    Sys.info()[["user"]]
  } |>
    conr::decode_text()
  proj_name <- conr::decode_text(proj_name)
  title <- paste("PROJECT README:", proj_name)
  date <- Sys.Date()
  date_text <- paste0("Analysis initiated ", conr::format_date(date), ".")
  text <- readLines( # read straight from template
    con = system.file(
      package = "conr", "rmarkdown", "templates", "html-template", "skeleton",
      "skeleton.Rmd"
    )
  )
  text <- sub("Title", title, text)
  text[3] <- paste0("date: \"", date_text, "\"")
  text[4] <- paste0("author: \"", author, "\"")
  writeLines(text, con = file.path("README.Rmd"), sep = "\n")
}

write_proj <- function(path) {
  text <- c(
    "Version: 1.0",
    "",
    "RestoreWorkspace: No",
    "SaveWorkspace: No",
    "AlwaysSaveHistory: No",
    "",
    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: Yes",
    "NumSpacesForTab: 2",
    "Encoding: UTF-8",
    "",
    "RnwWeave: Sweave",
    "LaTeX: pdfLaTeX",
    "",
    "AutoAppendNewline: Yes",
    "StripTrailingWhitespace: Yes"
  )
  proj <- paste0(basename(path), ".Rproj")
  writeLines(text, con = file.path(proj), sep = "\n")
}

write_folders <- function() {
  folders <- c(
    file.path("code", "checks"),
    file.path("data", "raw"),
    file.path("data", "supplementary"),
    "output"
  )
  lapply(folders, \(x) dir.create(path = x, recursive = TRUE))
  code_files <- c(
    "01_cleaning.R",
    "02_transformations.R",
    "03_results.R",
    "04_figures.R",
    "05_tables.R"
  )
  lapply(file.path("code", code_files), file.create)
  cli::cli_alert_success("Folders and blank scripts created.")
}

# not working - too hard? function to add packages once inside project?
# write_packages <- function(path) {
#   packages <- c(
#     "connor-ballinger/conr",
#     "tidyverse",
#     "knitr",
#     "rmarkdown"
#   )
#   R_version <- regexpr("\\d\\.\\d", R.version[["version.string"]]) |>
#     regmatches(R.version[["version.string"]], m = _)
#   R_version <- paste0("R-", R_version)
#
#   renv::install(
#     packages = packages,
#     dependencies = c("Depends", "Imports", "LinkingTo"),
#     lock = TRUE,
#     library = paste0(
#       path,
#       "/renv/library/windows/",
#       R_version,
#       "/",
#       R.version[["platform"]]
#     )
#   )
# }
