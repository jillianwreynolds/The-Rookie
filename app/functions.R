#' Get column of episode titles as a string
#'
#' Cleans episode title column, pulls the columm, and flattens the vector into a string.
#' @param tbl A tibble containing episode titles and ratings.
#'
#' @returns
#' @export
#'
#' @examples
titles_to_string <- function(tbl) {
  tbl |>
    mutate(string = str_c(title, " (", season, "x", episode, ")")) |>
    pull(string) |>
    str_flatten_comma(last = ", and ")
}

#' Clean column names for presentation
#'
#' Replaces underscores with spaces and converts column names to title cases.
#' @param tbl The table with columns to be cleaned.
#' @param ... 
#'
#' @returns
#' @export
#'
#' @examples
#' tibble(first_name = c("Lucy", "Tim"), last_name  = c("Chen", "Bradford")) |> 
#'   clean_col_names()
clean_col_names <- function(tbl, ...) {
  tbl |> 
    rename_with(
      \(x) x |> str_replace_all("_", " ") |> str_to_title(),
      ...
    )
}

#' Clean a column of first and last names
#'
#' Replaces all underscores with spaces and converts values to title case.
#' @param data The data with the column to clean.
#'
#' @returns
#' @export
#'
#' @examples
clean_chars_col <- function(data) {
  
  data |> 
    mutate(character = character |> str_replace_all("_", " ") |> str_to_title())
  
}
