# Making it easy to move to a new computer. These functions would be very rarely
# used - maybe they should be kept as internal functions?


#' Write preferences
#'
#' Existing preferences can be checked using
#' \code{\link[usethis]{edit_rstudio_prefs}}.
#'
#' Function must be used interactively. A menu asks you to confirm the decision
#' to overwrite preferences.
#'
#' To view the preferences file in the conr package, run the following code in
#' the console:
#'
#' \code{
#'   system.file(package = "conr", "preferences", "rstudio-prefs.json") |>
#'     file.edit()
#' }
#'
#' Some preferences you may wish to change:
#'
#' - "default_project_location": "~/coding",
#' - "initial_working_directory": "~/coding",
#' - "default_open_project_location": "~/coding",
#' - "editor_theme": "Chrome" or "Tomorrow Night" or ...
#'
#' Preferences can be most easily be changed using RStudio menus.
#'
#' I was going to use `usethis:::rstudio_config_path` but apparently internal
#' functions should not be used outside of a given package.
#'
#' @importFrom cli cli_abort
#' @importFrom cli cli_alert_info
#' @importFrom rappdirs user_config_dir
#' @importFrom rstudioapi documentClose
#' @importFrom rstudioapi documentOpen
#' @importFrom rstudioapi isAvailable
#' @importFrom rstudioapi restartSession
#' @importFrom utils menu
#'
#' @returns Invisible; path to \code{"rstudio-prefs.json"}.
#' @seealso [overwrite_profile()]
#' @export
#'
overwrite_preferences <- function() {
  if (!(interactive() & rstudioapi::isAvailable())) { # check
    cli::cli_abort("Function must be used interactively in RStudio.")
  }
  new_prefs <- system.file(package = "conr", "preferences", "rstudio-prefs.json")
  # if-else statement is from usethis:::rstudio_config_path.
  if (.Platform$OS.type == "windows") {
    base <- rappdirs::user_config_dir("RStudio", appauthor = NULL)
  } else {
    base <- rappdirs::user_config_dir("rstudio", os = "unix")
  }
  prefs <- file.path(base, "rstudio-prefs.json")
  doc_id <- rstudioapi::documentOpen(prefs)
  cli::cli_alert_info(
    "Your existing preferences file is shown in the Source pane.
    \n\n
    Would you like to overwrite these preferences?"
  )
  switch(
    utils::menu(
      c("No, keep my existing preferences.",
        paste(
          "Yes, overwrite my existing preferences with those from the conr",
          "package AND restart session (current session will be restored)."
        )
      )
    ),
    "1" = keep_prefs(doc_id),
    "2" = copy_prefs(doc_id, prefs, new_prefs)
  )
}

#' Keep/Copy preferences
#'
#' @param doc_id Open preferences file identifier.
#'
#' @importFrom cli cli_alert_info
#' @importFrom rstudioapi documentClose
#'
keep_prefs <- function(doc_id) {
  rstudioapi::documentClose(doc_id)
  cli::cli_alert_info("No, existing preferences have been kept.")
}

#' @rdname keep_prefs
#'
#' @param doc_id Open preferences file identifier.
#' @param prefs Existing preferences file.
#' @param new_prefs Preferences file from conr.
#'
#' @importFrom cli cli_alert_success
#' @importFrom rstudioapi documentClose
#' @importFrom rstudioapi documentOpen
#' @importFrom rstudioapi restartSession
#'
copy_prefs <- function(doc_id, prefs, new_prefs) {
  rstudioapi::documentClose(doc_id)
  # you can overwrite an open file but the file contents does not update.
  file.copy(new_prefs, prefs, overwrite = TRUE)
  rstudioapi::documentOpen(prefs)
  cli::cli_alert_success(
    "New preferences saved and displayed.
    Edit the open file to save further changes."
  )
  rstudioapi::restartSession()
  invisible(prefs)
}

#' Write .Rprofile
#'
#' This function overwrites the existing user `.Rprofile` with one found in
#' `conr`. The file includes some simple options documented in the `usethis`
#' package.
#'
#' Note that the function only runs interactively and a mini menu is displayed
#' after running the function to confirm your choice. If you already have code
#' in your `.Rprofile`, then nothing will happen except both `.Rprofile`s will
#' be displayed in the Source pane.
#'
#' To view the `.Rprofile` file in the `conr` package, run the following code in
#' the console:
#'
#' \code{
#'   system.file(package = "conr", "preferences", ".Rprofile") |>
#'     file.edit()
#' }
#'
#' The existing `.Rprofile` can be checked using
#' \code{\link[usethis]{edit_r_profile}(scope ="user")}.
#'
#' @importFrom cli cli_abort
#' @importFrom cli cli_alert_danger
#' @importFrom cli cli_alert_info
#' @importFrom cli cli_alert_success
#' @importFrom rstudioapi documentClose
#' @importFrom rstudioapi documentOpen
#' @importFrom rstudioapi restartSession
#' @importFrom utils menu
#'
#' @returns Invisible; path to \code{.Rprofile}.
#' @export
#' @seealso [overwrite_preferences()]
#'
overwrite_profile <- function() {
  if (!(interactive() & rstudioapi::isAvailable())) { # check - are these needed?
    cli::cli_abort("Function must be used interactively in RStudio.")
  }
  profile <- file.path("~/.Rprofile") # is it always here? fs::path_home_r?
  if (!file.exists(profile)) {
    cli::cli_abort("Existing profile not found at {.path {profile}}")
  }
  new_profile <- system.file(package = "conr", "preferences", ".Rprofile")
  if (!file.size(profile)) {
    rstudioapi::documentOpen(profile)
    rstudioapi::documentOpen(new_profile)
    cli::cli_alert_danger(
      "There is already text within the existing profile.\n
      Both the existing {.path {profile}} and the profile from the conr package
      are displayed in the Source pane.\n
      Decide if you would like to make any changes to the existing
      {.path {profile}}."
    )
  } else {
    cli::cli_alert_info(
      "Your current {.path {profile}} is empty.
      \n
      Would you like to add code from the profile in the conr package to your
      {.path {profile}}?"
    )
    switch(
      utils::menu(
        c("No, keep my profile blank.",
          paste(
            "Yes, overwrite my existing profile with code from the conr",
            "package AND restart session (current session will be restored)."
          )
        )
      ),
      "1" = keep_prof(),
      "2" = copy_prof(new_profile, profile)
    )
  }
  invisible(profile)
}

#' Keep/Copy profile
#'
#' @importFrom cli cli_alert_info
#' @importFrom rstudioapi documentClose
#'
keep_prof <- function() {
  cli::cli_alert_info("No, the existing {.path {profile}} has been kept.")
}

# Copy profile

#' @rdname keep_prof
#'
#' @param new New profile.
#' @param old Old profile.
#'
#' @importFrom cli cli_alert_success
#' @importFrom rstudioapi documentOpen
#' @importFrom rstudioapi restartSession
#'
copy_prof <- function(new, old) {
  file.copy(new, old, overwrite = TRUE)
  rstudioapi::documentOpen(old)
  cli::cli_alert_success(
    "New {.path {old}} saved and displayed.
    Edit the open file to save further changes."
  )
  rstudioapi::restartSession()
}

# #' Write snippets
# #'
# #' This function writes two particular snippets for captioning tables and
# #' figures in `rmarkdown`/`Quarto` code chunks. Snippets can be checked using
# #' \code{\link[usethis]{edit_rstudio_snippets}(type = "r")} (or simply Tools ->
# #' Edit Code Snippets on the RStudio menu).
# #'
# #' @importFrom rappdirs user_config_dir
# #' @returns
# #' @export
# #'
# #' @examples
# write_snippets <- function() {
#   file_snippets <- rappdirs::user_config_dir("RStudio", NULL) |>
#     file.path("snippets", "r.snippets")
#   if (file.exists(file_snippets)) {
#     cli::cli_alert_success("Snippets file found at {.path {file_snippets}}")
#   } else {
#     cli::cli_abort(
#       c(
#         "x" = "Snippets file expected at {.path {file_snippets}} but not found."
#       )
#     )
#   }
#   # existing snippets
#   snippets <- readLines(file_snippets)
#   # check extra snippets do not already exist
#   # abort or warn?
#   if (sum(grepl("snippet tab", snippets)) != 0) {
#     cli::cli_abort("New snippets may already be present in snippets file.")
#   }
#   new_snippets <- c(
#     "snippet tab",
#     "  #| tab.id = \"tab\",",
#     "  #| tab.cap = \"${1:caption}\"",
#     "",
#     "snippet fig",
#     "  #| fig.id = \"fig\",",
#     "  #| fig.cap = \"${1:caption}\"",
#     ""
#   )
#   new_snippets <- c(new_snippets, snippets)
#   writeLines(new_snippets, con = file_snippets, sep = "\n")
#   cli::cli_alert_success("New snippets successfully added.")
# }
