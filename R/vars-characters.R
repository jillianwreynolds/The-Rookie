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
  names = c("first_name", "last_name")
) |> 
  mutate(across(ends_with("name"), str_to_upper))

# Main characters from Wikipedia table -----------------------------------------

main_chars_wide <- "characters.csv" |> 
  read_csv(show_col_types = FALSE) |> 
  relocate(actor, .after = last_col())

main_chars_long <- main_chars_wide |> 
  pivot_longer(
    starts_with("season"), names_to = "season", values_to = "status"
  ) |> 
  relocate(actor, .after = last_col()) |> 
  mutate(
    across(starts_with("char"), str_to_upper),
    season = season |> str_remove("season_") |> as.integer()
  )

# Recurring characters from Wikipedia list --------------------------------

recurring_chars_wide <- "recurring_characters.csv" |> 
  read_csv(show_col_types = FALSE) |> 
  mutate(
    row = row_number(),
    actor = text |> str_extract("^.+?(?=\\sas\\s)"),
    character = text |> str_extract("(?<=\\sas\\s).+?(?=\\:|\\s\\()"),
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
    ) |> 
      as_tibble()
  ) |> 
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

recurring_chars_long <- recurring_chars_wide |> 
  pivot_longer(
    starts_with("season"), names_to = "season", values_to = "status"
  ) |> 
  relocate(c(actor, text), .after = last_col()) |> 
  mutate(season = season |> str_remove("season") |> as.integer())


# -------------------------------------------------------------------------

women <- c(
  "Abigail", "Abril", "Angela",
  "Bailey", "Blair",
  "Celina",
  "Fiona",
  "Genny", "Grace",
  "Isabel",
  "Jessica",
  "Lila", "Lucy", "Luna",
  "Monica",
  "Nell", "Nyla",
  "Rachel", "Rosalind",
  "Sandra",
  "Talia", "Tamara",
  "Vivian",
  "Zoe"
) |> 
  str_to_upper()

men <- c(
  "Aaron",
  "Ben",
  "Chris",
  "Donovan", "Doug",
  "Elijah", "Emmett",
  "Henry",
  "Jackson", "James", "Jason", "John",
  "Kevin",
  "Liam",
  "Malcolm", "Miles",
  "Nicholas",
  "Oscar",
  "Percy",
  "Quigley",
  "Randy", "Rodge", "Ruben",
  "Sean", "Seth", "Sterling",
  "Tim",
  "Wade", "Wesley"
) |> 
  str_to_upper()

# c(women, men) is one element shorter than characters$first_name because two
# Elijah's

# Characters --------------------------------------------------------------

char_status_long<- bind_rows(
  main_chars_long |> mutate(type = "main"),
  recurring_main_chars_long |> mutate(type = "recurring")
) |> 
  select(-c(row, text))

char_status_wide <- char_status_long|> 
  pivot_wider(
    names_from = season,
    names_prefix = "season_",
    values_from = status
  ) |> 
  relocate(actor, .after = last_col())

characters <- char_status_long|> 
  select(starts_with("char"), type) |> 
  distinct() |> 
  rename_with(.cols = starts_with("char"), \(x) {
    x |> str_remove("character_") %>% str_c(., "_name")
  }) |> 
  mutate(gender = if_else(first_name %in% women, "F", "M"), .before = type)
