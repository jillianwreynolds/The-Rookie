draw_best_worst_eps_speakers_plot <- function(data, ratings, filter_characters) {
  
  word_count <- data |>
    filter(type == "dialogue") |>
    group_by(season, episode) |>
    count() |>
    rename(total_words = n)
  
  tbl <- data |>
    filter(type == "dialogue") |>
    filter_characters("top6") |>
    left_join(ratings(), join_by(season, episode))
  
  highest <- tbl |>
    slice_max(rating)
  
  lowest <- tbl |>
    slice_min(rating)
  
  draw_plot <- function(tbl) {
    tbl |>
      group_by(sp4, season, episode) |>
      count() |>
      left_join(word_count, join_by(season, episode)) |>
      mutate(
        prop = n / total_words,
        episode = str_c(season, "x", episode),
        sp4 = sp4 |> str_to_title()
      ) |>
      ggplot(aes(episode, prop)) +
      geom_col(aes(fill = sp4), position = "dodge") +
      scale_y_continuous(expand = expansion(c(0, 0.05))) +
      scale_fill_viridis_d(end = 0.9, direction = -1) +
      labs(
        x = "Episode", y = "Proportion of Total Words", fill = "Character"
      ) +
      gg_theme
  }
  
  (draw_plot(highest) + labs(title = "Highest Rated")) +
    (draw_plot(lowest) + labs(title = "Lowest Rated")) +
    plot_layout(
      guides = "collect", axis_titles = "collect_y", axes = "collect_y"
    ) &
    coord_cartesian(ylim = c(0, 0.175)) &
    theme(plot.title = element_text(size = 17), legend.position = "bottom")
  
}
