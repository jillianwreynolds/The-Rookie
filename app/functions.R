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
      \(x) {
        x |> 
          str_replace_all("_", " ") |> 
          str_to_title() |> 
          str_replace("(?<= )Of(?= )", "of") |> 
          str_replace("(?<= )Per(?= )", "per")
      },
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
#' tibble(character = c("LUCY CHEN", "SEAN_DEL_MONTE")) |> clean_chars_col()
clean_chars_col <- function(data) {
  
  data |> 
    mutate(character = character |> str_replace_all("_", " ") |> str_to_title())
  
}

#' Wrap insight::format_value()
#'
#' Wraps `insight::format_value()` and sets `big_mark = ","`.
#' @param x Numeric value.
#' @param big_mark A string to insert as thousands separator.
#' @param ... 
#'
#' @returns A formatted string.
#' @export
#'
#' @examples
#' fmt_value(1234)
fmt_value <- function(x, digits = 2, big_mark = ",", ...) {
  
  format_value(
    x,
    digits = digits,
    big_mark = big_mark,
    ...
  )
  
}
