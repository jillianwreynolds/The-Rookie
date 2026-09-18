"data/Wikipedia/recurring_characters.parquet" |>
  read_parquet() |> 
  mutate(
    actor = text |> str_extract("^.+?(?=\\sas\\s)"),
    character = text |> str_extract("(?<=\\sas\\s).+?(?=\\:|(\\s\\())"),
    seasons = text |>
      str_extract("(?<=\\().+(?=\\))") |> 
      str_replace_all("\\-|–", ":") |>
      str_replace_all("present", "8") |>
      str_replace_all("\\d+\\:\\d+", \(x) str_range_to_num_range(x, ", ")) |> 
      str_remove_all("(guest\\s)?seasons?\\s"),
    .before = text
  ) |> 
  separate_wider_delim(
    seasons,
    delim = "; ",
    names = c("recurring", "guest"),
    too_few = "align_start"
  ) |> 
  pivot_longer(
    c(recurring, guest),
    names_to = "status",
    values_to = "season"
  ) |> 
  relocate(c(season, status), .before = text) |> 
  separate_longer_delim(season, ", ") |> 
  filter_out(is.na(season), str_detect(text, "season")) |> 
  mutate(
    season = season |> as.integer(),
    alias = case_when(
      str_detect(character, "\"") ~ character |> str_extract("(?<=\").+(?=\")"),
      str_detect(character, "/")  ~ str_extract(character, "(?<= / ).+")
    ),
    character = character |> 
      str_remove("\".+\"\\s") |>
      str_remove(" / .+") |>
      str_remove("Dr.\\ ") |> 
      str_replace("Del Monte", "Del_Monte") |> 
      str_replace("de la Cruz", "de_la_Cruz") |> 
      str_to_upper(),
    .before = text
  ) |>
  separate_wider_delim(
    character,
    delim = " ",
    names = c("first_name", "last_name")
  ) |> 
  relocate(c(first_name:status, actor)) |> 
  select(-c(alias, text))
  # print_inf()

"data/Wikipedia/recurring_characters.parquet" |> 
  create_recurring_chars_long()

"data/Wikipedia/recurring_characters.parquet" |> 
  create_recurring_chars_long() |> 
  pivot_wider(
    names_from = season, values_from = status
  ) |> 
  relocate(actor, .after = last_col()) |> 
  rename_with(.cols = 3:11, \(x) str_c("season_", x)) |> 
  unnest(starts_with("season")) |> 
  # arrange(across(starts_with("season"))) |> 
  print_inf()

"data/Wikipedia/recurring_characters.parquet" |> 
  create_recurring_chars_long() |> 
  arrange(season) |> 
  mutate(season = str_c("season_", season)) |> 
  pivot_wider(
    id_cols = c(first_name, last_name, actor),
    names_from = season,
    values_from = status
  ) |> 
  relocate(actor, .after = last_col())
  
