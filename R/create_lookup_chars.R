create_lookup_chars <- function(chars_data) {
  
  bind_rows(
    move_first_add_last_tbl |> mutate(type = "move_first_add_last"),
    add_first_tbl |> mutate(type = "add_first")
  ) |>
    mutate(
      replacement = if_else(
        type == "move_first_add_last",
        name |> recode_values(
          from = chars_data$first_name,
          to   = chars_data$last_name
        ),
        NA_character_
      ),
      replacement = if_else(
        type == "add_first",
        name |> recode_values(
          from = chars_data$last_name,
          to   = chars_data$first_name
        ),
        replacement
      ),
      replacement = if_else(
        is.na(replacement),
        name |> recode_values(
          from = additional_chars$name,
          to = additional_chars$replacement
        ),
        replacement
      ),
      replacement = replacement |> str_replace_all("NICHOLAS", "NICK")
    ) |>
    relocate(replacement, .after = name)
  
}
