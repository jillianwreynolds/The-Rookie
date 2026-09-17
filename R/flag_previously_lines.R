# flag_previously_lines <- function(tbl) {
#   
#   tbl
#   
# }
# 
# previously_lines <- df_raw |> 
#   select(season:type) |> 
#   filter(type == "previously") |> 
#   collect()
# 
# end_recap <- df_raw |> 
#   select(season:type) |> 
#   filter(type == "scene_heading") |> 
#   collect() |> 
#   slice_min(line, by = c(season, episode))
# 
# bind_rows(previously_lines, end_recap) |> 
#   group_by(season, episode) |> 
#   arrange(season, episode) |> 
#   pivot_wider(names_from = type, values_from = line) |> 
#   relocate(previously, .before = scene_heading) |> 
#   filter_out(is.na(previously)) |>
#   filter(is.na(scene_heading)) |>
#   # filter_out(is.na(scene_heading)) |>
#   ungroup() |> 
#   gt()
# 
#  df_raw |> 
#   select(season:type, speaker, transcript) |> 
#   collect() |> 
#   mutate(rowID = row_number(), .before = season) |> 
#   mutate(
#     previously = if_else(line == 1, TRUE, FALSE)
#   )
