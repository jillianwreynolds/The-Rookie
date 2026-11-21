write_top6_summary_stats_tbl <- function(data) {
  
  tbl <- data |> 
    group_by(sp4, season, episode) |> 
    count() |> 
    ungroup()
  
  tbl <- tbl |> 
    group_by(sp4, season) |> 
    summarise(
      min  = min(n),
      max  = max(n),
      mean = mean(n),
      sd   = sd(n),
      .groups = "drop"
    ) |> 
    mutate(sp4 = sp4 |> str_to_title()) |> 
    rename(Character = sp4, minimum = min, maximum = max) |> 
    clean_col_names() |> 
    rename(SD = Sd)
  
  gt <- tbl |> 
    gt() |> 
    fmt_number(c("Mean", "SD"), drop_trailing_zeros = FALSE) |> 
    cols_align_decimal()
  
  gt |>
    opt_interactive(
      use_sorting = TRUE,
      use_highlight = TRUE,
      page_size_default = 10,
      use_page_size_select = TRUE,
      page_size_values = c(10, 20)
    )
  
}
