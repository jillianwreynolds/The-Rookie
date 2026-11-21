create_characters <- function(tbl) {
  
  tbl |>
    select(ends_with("name"), gender, type, actor) |>
    distinct()
  
}
