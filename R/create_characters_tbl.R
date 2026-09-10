create_characters_tbl <- function(tbl) {
  
  tbl |>
    select(ends_with("name"), type) |>
    distinct() |>
    mutate(gender = if_else(first_name %in% women, "F", "M"), .before = type)
  
}
