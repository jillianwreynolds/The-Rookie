create_characters <- function(tbl) {
  
  tbl |>
    select(ends_with("name"), type, actor) |>
    distinct() |>
    mutate(
      gender = case_when(
        first_name %in% women ~ "F",
        first_name %in% men   ~ "M",
        when_all(is.na(first_name), last_name %in% women) ~ "F",
        when_all(is.na(first_name), last_name %in% men)   ~ "M",
        last_name == "MORGAN" ~ "F",
        last_name == "PALOMA" ~ "M"
      ),
      .before = type
    )
  
}
