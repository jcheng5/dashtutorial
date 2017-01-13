summon <- function(dest_path = getwd(), overwrite = FALSE) {
  dest <- file.path(dest_path, "dashtutorial")
  message("Copying tutorial files to ", dest)
  dir.create(dest, recursive = TRUE)
  file.copy(
    system.file("ui", package = "dashtutorial"),
    dest,
    recursive = TRUE,
    overwrite = overwrite
  )
  file.copy(
    system.file("server", package = "dashtutorial"),
    dest,
    recursive = TRUE,
    overwrite = overwrite
  )
  file.copy(
    system.file("dashtutorial.Rproj", package = "dashtutorial"),
    dest,
    recursive = TRUE,
    overwrite = overwrite
  )
  invisible()
}
