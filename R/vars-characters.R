main_chars <- tribble(
  ~name,             ~gender,
  "John Nolan",       "M",
  "Lucy Chen",        "F",
  "Tim Bradford",     "M",
  "Angela Lopez",     "F",
  "Wade Grey",        "M",
  "Nyla Harper",      "F"
) |> separate_wider_delim(
  name,
  delim = " ",
  names = c("first_name", "last_name"),
  too_many = "merge"
) |> 
  mutate(across(ends_with("name"), str_to_upper))

characters_tribble <- tribble(
  ~name,             ~gender,
  "John Nolan",       "M",
  "Lucy Chen",        "F",
  "Jackson West",     "M",
  "Tim Bradford",     "M",
  "Angela Lopez",     "F",
  "Talia Bishop",     "F",
  "Nyla Harper",      "F",
  "Wade Grey",        "M",
  "Aaron Thorsen",    "M",
  "Celina Juarez",    "F",
  "Miles Penn",       "M",
  "Seth Ridley",      "M",
  "Quigley Smitty",   "M",
  "Wesley Evers",     "M",
  "James Murray",     "M",
  "Bailey Nune",      "F",
  "Tamara Colins",    "F",
  "Luna Grey",        "F",
  "Rodge Bronson",    "M",
  "Sean Del Monte",   "M",
  "Genny Bradford",   "F",
  "Chris Sanford",    "M",
  "Randy Spitz",      "M"
  # "Zoe Andersen",     "F",
  # "Nell Forester",    "F",
  # "Isabel Bradford",  "F",
  # "Henry Nolan",      "M",
  # "Abigail Tierney",  "F",
  # "Ben McRee",        "M",
  # "Percy West",       "M",
  # "Jessica Russo",    "F",
  # "Grace Sawyer",     "F",
  # "Oscar Hutchinson", "M",
  # "Nick Armstrong",   "M",
  # "Rosalind Dyer",    "M",
  # "Monica Stevens",   "F",
  # "Elijah Stone",     "M",
  # "Liam Glasser",     "M",
  # "Malcolm Walsh",    "M",
  # "Vivian Eckert",    "F"
) |> 
  separate_wider_delim(
    name,
    delim = " ",
    names = c("first_name", "last_name"),
    too_many = "merge"
  ) |> 
  mutate(caps = str_to_upper(last_name))


# Main characters from Wikipedia table -----------------------------------------

characters_df <- "characters.csv" |> 
  read_csv(show_col_types = FALSE) |> 
  relocate(actor, .after = last_col())

characters_long <- characters_df |> 
  pivot_longer(
    starts_with("season"), names_to = "season", values_to = "status"
  ) |> 
  relocate(actor, .after = last_col()) |> 
  mutate(
    across(starts_with("char"), str_to_upper),
    season = season |> str_remove("season_") |> as.integer()
  )

# Recurring characters from Wikipedia list --------------------------------

recurring_characters <- "recurring_characters.csv" |> 
  read_csv(show_col_types = FALSE) |> 
  mutate(
    row = row_number(),
    actor = text |> str_extract("^.+?(?=\\sas\\s)"),
    character = text |> str_extract("(?<=\\sas\\s).+?(?=\\:|\\s\\()"),
    # character = text |> str_extract("(?<=\\sas\\s).+(?=\\s\\()"),
    # character = if_else(
    #   !str_detect(text, "\\(season"),
    #   str_extract(text, "(?<=\\s\\as\\s).+(?=\\:)"),
    #   character
    # ),
    seasons = text |> 
      str_extract("(?<=\\().+(?=\\))") |> 
      str_replace_all("\\-|–", ":") |> 
      str_replace_all("present", "8") |> 
      str_replace_all("1:2", "1, 2") |> 
      str_replace_all("1:3", "1, 2, 3") |> 
      str_replace_all("2:3", "2, 3") |> 
      str_replace_all("3:7", "3, 4, 5, 6, 7") |> 
      str_replace_all("3:8", "3, 4, 5, 6, 7, 8") |> 
      str_replace_all("4:5", "4, 5") |> 
      str_replace_all("4:8", "4, 5, 6, 7, 8") |> 
      str_replace_all("5:6", "5, 6") |> 
      str_replace_all("5:8", "5, 6, 7, 8") |> 
      str_replace_all("6:7", "6, 7") |> 
      str_replace_all("7:8", "7, 8"),
    .before = text
  ) |> 
  separate_wider_delim(
    seasons,
    delim = "; ",
    names = c("recurring", "guest"),
    too_few = "align_start"
  ) |> 
  mutate(
    guest = guest |> str_remove("guest\\sseasons?\\s"),
    recurring = recurring |> str_remove("seasons?\\s")
  ) |>
  separate_longer_delim(recurring, ", ") |> 
  separate_longer_delim(guest,", ") |> 
  mutate(
    col_name = str_c("season", recurring),
    col_name2 = str_c("season", guest)
  ) |>
  arrange(col_name, col_name2) |> 
  mutate(
    recurring = recurring |> str_replace(".", "recurring"),
    guest = guest |> str_replace(".", "guest")
  ) |> 
  pivot_wider(
    names_from = c(col_name),
    values_from = c(recurring)
  ) |> 
  arrange(col_name2) |> 
  pivot_wider(
    names_from = col_name2, values_from = guest, names_prefix = "g_"
  ) |>
  arrange(row) |> 
  mutate(
    map2(
      tibble(season3, season4, season5, season6, season7, season8),
      tibble(g_season3, g_season4, g_season5, g_season6, g_season7, g_season8),
      \(x, y) x = coalesce(x, y)
    ) |> as_tibble()
    # season3 = coalesce(season3, g_season3),
    # season4 = coalesce(season4, g_season4),
    # season5 = coalesce(season5, g_season5),
    # season6 = coalesce(season6, g_season6),
    # season7 = coalesce(season7, g_season7),
    # season8 = coalesce(season8, g_season8),
  ) |> 
  # pivot_wider(
  #   names_from = c(col_name, col_name2),
  #   values_from = c(recurring, guest)
  # ) |>
  # mutate(
  #   across(starts_with("season"), \(x) x |> str_replace_all(".", "recurring"))
  # ) |> 
  select(row:season8) |>
  relocate(text, .after = last_col()) |> 
  mutate(character = character |> 
           str_remove(coll("\"Nick\" ")) |> 
           str_remove(coll(" / Skipper Young")) |> 
           str_remove("^Dr\\.\\s") |> 
           str_replace("Del\\sMonte", "Del_Monte") |> 
           str_replace(
             coll("Sandra \"La Fiera\" de la Cruz"),
             "Sandra de_la_Cruz"
           ) |> 
           str_remove(coll("\"Skip Tracer\" "))
  ) |> 
  separate_wider_delim(
    character, " ", names = c("character_first", "character_last")
  ) |> 
  mutate(across(starts_with("char"), str_to_upper))
  
recurring_characters |>   
  gt() |> 
  tab_style(
    style = cell_fill("grey95"),
    locations = list(
      cells_body(columns = matches("[13579]")),
      cells_column_labels(columns = matches("[13579]"))
    )
  )

recurring_characters_long <- recurring_characters |> 
  pivot_longer(
    starts_with("season"), names_to = "season", values_to = "status"
  ) |> 
  relocate(c(actor, text), .after = last_col()) |> 
  mutate(season = season |> str_remove("season") |> as.integer())


# Characters --------------------------------------------------------------

character_status <- bind_rows(
  characters_long |> mutate(type = "main"),
  recurring_characters_long |> mutate(type = "recurring")
) |> 
  select(-c(row, text))

character_status_wide <- character_status |> 
  pivot_wider(
    names_from = season,
    names_prefix = "season_",
    values_from = status
  ) |> 
  relocate(actor, .after = last_col())

characters <- character_status |> 
  select(starts_with("char"), type) |> 
  distinct()
