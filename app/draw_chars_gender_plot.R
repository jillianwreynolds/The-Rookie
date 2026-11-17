draw_chars_gender_plot <- function(data) {
  
  tbl <- data |> 
    filter_out(is.na(season)) |> 
    group_by(season, gender) |> 
    count(type) |> 
    mutate(
      season = season |> as_factor(),
      type = type |> str_to_title() |> fct_relevel(c("Main", "Recurring")),
      gender = gender |> 
        replace_when(
          gender == "F" ~ "Women",
          gender == "M" ~ "Men"
        ) |> 
        fct_rev()
    )
  
  p4 <- data |> 
    filter(type == "notable") |> 
    distinct() |> 
    group_by(gender) |> 
    count(type) |> 
    mutate(gender = gender |> 
             replace_when(
               gender == "F" ~ "Women",
               gender == "M" ~ "Men"
             ) |> 
             fct_rev()
    ) |> 
    ggplot(aes(gender, n, fill = gender)) +
    geom_col(width = 0.125) +
    scale_y_continuous(expand = expansion(c(0, 0.05))) +
    scale_fill_manual(
      values = c("Women" = "#440154FF", "Men" = "#1FA187FF"),
      guide = NULL
    ) +
    labs(title = "Notable", x = "Gender", y = "Number of Characters", fill = "Gender") +
    gg_theme
  
  map(
    list("Main", "Recurring", "Crossover"),
    \(x) tbl |> 
      filter(type == x) |> 
      ggplot(aes(season, n, fill = gender)) + 
      geom_col(position = "dodge") +
      scale_y_continuous(
        breaks = seq(0, 12, 2),
        expand = expansion(c(0, 0.05))
      ) +
      scale_x_discrete(drop = FALSE) +
      scale_fill_viridis_d(end = 0.6) +
      coord_cartesian(ylim = c(0, 12)) +
      labs(
        title = x,
        x = "Season",
        y = "Number of Characters",
        fill = "Gender"
      ) +
      gg_theme
  ) |> 
    reduce(`+`) +
    p4 +
    plot_layout(
      guides = "collect",
      axes = "keep",
      axis_titles = "collect_y"
    ) &
    theme(
      plot.title = element_text(size = 17)
    )
  
}
