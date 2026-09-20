titles_to_string <- function(tbl) {
  tbl |>
    mutate(string = str_c(title, " (", season, "x", episode, ")")) |>
    pull(string) |>
    str_flatten_comma(last = ", and ")
}

clean_col_names <- function(tbl, ...) {
  tbl |> 
    rename_with(
      \(x) x |> str_replace_all("_", " ") |> str_to_title(),
      ...
    )
}
