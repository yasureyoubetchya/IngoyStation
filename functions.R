check_create_dir <- function(the_dir) {
  if (!dir.exists(the_dir)) {
    dir.create(the_dir, recursive = TRUE) }
}