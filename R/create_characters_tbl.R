create_characters_tbl <- function(tbl) {
  
  tbl |>
    select(ends_with("name"), type, actor) |>
    distinct() |>
    mutate(
      gender = case_when(
        first_name %in% women ~ "F",
        first_name %in% men   ~ "M"
      ),
      .before = type
    )
  
}
