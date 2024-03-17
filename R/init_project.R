#' Initiate Project
#'
#' @description
#' Create a new project with some folder structures and preferences in place.
#' Similar examples:
#'
#' https://rstudio.github.io/rstudio-extensions/rstudio_project_templates.html
#' https://github.com/jonas-hag/analysistemplates/
#' https://github.com/rostools/prodigenr/blob/main/R/setup_project.R
#'
#'
#' @param path String for desired directory.
#' @param use_renv TRUE/FALSE Use renv?
#' @param use_git TRUE/FALSE Use Git?
#' @param use_folders TRUE/FALSE Use the default directory structure, with some
#'  blank files.
#' @param ... Dots.
#'
#' @return A project.
#' @export
#'
#' @importFrom cli cli_alert_info
#' @importFrom cli cli_alert_success
#' @importFrom cli cli_alert_warning
#' @importFrom fs dir_tree
#' @importFrom gert git_add
#' @importFrom gert git_commit_all
#' @importFrom gert git_config
#' @importFrom gert git_init
#' @importFrom renv init
#'
#' @examples

# readme.Rmd
# add github - remote

init_project <- function(path, use_renv = TRUE, use_git = TRUE,
                         use_folders = TRUE, ...) {

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
  cli::cli_alert_success("Directory {.path {path}} created.")

  setwd(path)

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
  }

  file.create("README.md")
  write_readme(path = path, use_git = use_git)

  if (use_git) {
    gert::git_add(files = ".")
    gert::git_add(files = ".gitignore") # has to be manually added
    gert::git_commit_all(message = "Initial commit")
    cli::cli_alert_success("Initial changes have been committed.")
  }

  cli::cli_alert_info("Project overview:")
  fs::dir_tree(recurse = 2)
}

write_readme <- function(path, use_git, ...) {
  text = c(
    "# PROJECT README",
    paste("**Project short name**:", basename(path)),
    "**Project long name**: ",
    paste("**Analysis initiated**:", conr::format_date()),
    if (use_git) {
      paste(
        "**Analysis by**:", gert::git_config() |>
          subset(name == "user.name", "value", drop = TRUE)
      )
    }, else {
      paste(
        "**Analysis by**:", Sys.info()[["user"]]
      )
    }
    "**Project description**: ",
    "**Notes**: "
  )
  writeLines(text, con = file.path("README.md"), sep = "\n\n")
}

write_proj <- function(path) {
  text = c(
    "Version: 1.0",
    "",
    "RestoreWorkspace: No",
    "SaveWorkspace: No",
    "AlwaysSaveHistory: No",
    "",
    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: No",
    "NumSpacesForTab: 2",
    "Encoding: UTF-8",
    "",
    "RnwWeave: Sweave",
    "LaTeX: pdfLaTeX",
    "",
    "AutoAppendNewline: Yes",
    "StripTrailingWhitespace: Yes"
  )
  proj = paste0(basename(path), ".Rproj")
  writeLines(text, con = file.path(proj), sep = "\n")
}

write_folders <- function() {

  folders = c(
    file.path("code", "checks"),
    file.path("data", "raw"),
    file.path("data", "supplementary"),
    "output"
  )

  lapply(X = folders, FUN = \(x) dir.create(path = x, recursive = TRUE))

  code_files = c(
    "01_cleaning.R",
    "02_transformations.R",
    "03_results.R",
    "04_figures.R",
    "05_tables.R"
  )

  lapply(X = file.path("code", code_files), FUN = file.create)
  cli::cli_alert_success("Folders and blank scripts created.")

}
