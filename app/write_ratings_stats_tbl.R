write_ratings_stats_tbl <- function(data) {
  
  tbl <- data |> 
    mutate(
      season = season |> as.character(),
      across(c(q1:q3, mean, sd), \(x) round(x, 2))
    ) |> 
    relocate(max, .after = q3) |> 
    rename(minimum = min, maximum = max) |>
    clean_col_names() |> 
    rename(SD = Sd)
  
  reactable(
    tbl,
    columns = list(
      Season = colDef(sticky = "left")
    )
  )
  # tbl |> 
  # gt() |> 
  # fmt_number(drop_trailing_zeros = FALSE) |> 
  # cols_align("center", "Season") |> 
  # # cols_width(
  # #   "Season" ~ px(100),
  # #   starts_with("Q") ~ px(80),
  # #   matches("^M(i|a|(ed))") ~ px(100),
  # #   "Mean" ~ px(80),
  # #   "SD" ~ px(75)
  # # ) |> 
  # opt_interactive(
  #   use_pagination = FALSE,
  #   use_sorting = TRUE,
  #   use_highlight = TRUE
  # )  
  
}

