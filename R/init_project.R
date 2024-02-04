# https://github.com/jonas-hag/analysistemplates/
# https://rstudio.github.io/rstudio-extensions/rstudio_project_templates.html

#' Start a Project
#'
#' @param path
#' @param new_session
#' @param renv
#' @param use_git
#' @param use_github
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
init_project <- function(path = "~/projects", new_session = TRUE, renv = TRUE,
                         use_git = TRUE, use_github = FALSE, ...) {

  # where does the directory's name come from? e.g. ~/projects/my_repo

  # create directory
  dir.create(path, recursive = TRUE)

  folders = c(
    "code",
    "code/checks",
    "data",
    "data/raw",
    "data/supplementary",
    "output"
  )

  vapply(paste0(path, folders), dir.create)

  code_files = c(
    "01_cleaning.R",
    "02_transformations.R",
    "03_results.R",
    "04_figures.R",
    "05_tables.R"
  )

  vapply(paste0(path, "/code/", code_files), dir.create)

  file.create("README.md")

  rstudioapi::initializeProject(path)

  # rstudioapi::writeRStudioPreference()
  # rstudioapi::userIdentity()
  # rstudioapi::showPrompt()

  if (renv) {
    if (requireNamespace("renv")) {
      renv::init()
    } else warning("Install renv first with `install.packages('renv')`.")
  }

  # gert::user_is_configured()

  if (use_git) { # or usethis::use_git(hub)
    if (requireNamespace("gert")) {
      gert::git_init(path = path)
    }
  }

  rstudioapi::openProject(path, new_session)
  # rstudioapi::navigateToFile()

}

write_readme <- function() {
  text = c(
    "README"
  )
  writeLines(text, file.path(path, "README.md"))
}
