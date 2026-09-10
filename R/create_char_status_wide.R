create_char_status_wide <- function(tbl) {
  
  tbl |>
    pivot_wider(
      names_from = season,
      names_prefix = "season_",
      values_from = status
    ) |>
    relocate(actor, .after = last_col())
  
}
