
# crossovers ---------------------------------------------------------

"data/Wikipedia/crossover_characters.txt" |> 
  create_crossover_chars_long() |> 
  mutate(
    row = row_number(),
    season = str_c("season_", season)
  ) |>
  arrange(season) |> 
  pivot_wider(
    id_cols = c(first_name, last_name, actor),
    names_from = season,
    values_from = status
  ) |>
  # arrange(row) |>
  relocate(actor, .after = last_col())


"data/Wikipedia/crossover_characters.txt" |> 
  create_crossover_chars_long() |> 
  create_crossover_chars_wide()


# notable guests ----------------------------------------------------------

"data/Wikipedia/notable_guests.txt" |> 
  read_file() |> 
  str_remove_all("\\[.+?\\]") |> 
  str_remove_all("Dr\\. (?!Morgan)") |> 
  str_replace("Mrs\\.(?=\\sChen)", "Vanessa") |> 
  str_replace(
    coll("Jeffrey Boyle / Eli Reynolds"),
    "Eli Reynolds / Jeffrey Boyle"
  ) |> 
  str_split("\n") |> 
  unlist() |> 
  tibble(text = _) |> 
  filter_out(str_detect(text, coll("as Jake Butler and Sava Wu"))) |> 
  mutate(
    actor = text |> str_extract(".+?(?=\\sas\\s)"),
    character = text |> str_extract("(?<=\\sas\\s).+(?=[:])"),
    character = character |> 
      replace_when(str_detect(text, "(her|him)self") ~ actor) |> 
      str_to_upper(),
    .before = text
  ) |> 
  separate_wider_delim(
    character, delim = " / ", names = c("character", "alias"),
    too_few = "align_start",
    cols_remove = FALSE
  ) |> 
  mutate(
    alias = alias |> replace_when(
      str_detect(character, "\"") ~ str_extract(character, "(?<=\").+(?=\")")
    ),
    character = character |> 
      str_remove("\\s/\\s.+") |> 
      str_remove("\".+\"\\s"),
  ) |> 
  print_inf()
  
"data/Wikipedia/notable_guests.txt" |> 
  create_notable_guest_chars()

# characters --------------------------------------------------------------
  
create_characters_long(
  main_chars_long,
  recurring_chars_long,
  crossover_chars_long,
  notable_guest_chars
) |> 
  distinct(first_name, last_name, .keep_all = TRUE) |> 
  print_inf()

create_characters_long(
  main_chars_long,
  recurring_chars_long,
  crossover_chars_long,
  notable_guest_chars
) |> 
  create_characters() |> 
  print_inf()

create_characters_long(
  main_chars_long,
  recurring_chars_long,
  crossover_chars_long,
  notable_guest_chars
) |> 
  create_characters() |> 
  create_lookup_chars() |> 
  print_inf()
