create_recurring_chars_long <- function(tbl) {
  
  tbl |>
    pivot_longer(
      starts_with("season"), names_to = "season", values_to = "status"
    ) |>
    relocate(c(actor, text), .after = last_col()) |>
    mutate(season = season |> str_remove("season") |> as.integer())
  
}
