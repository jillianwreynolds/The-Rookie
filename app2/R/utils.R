clean_col_names <- function(tbl, ...) {
  
  tbl |> 
    rename_with(
      \(x) x |> str_replace_all("_", " ") |> str_to_title(),
      ...
    )
  
}
