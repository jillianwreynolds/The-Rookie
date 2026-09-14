create_crossover_chars_long <- function(file_path) {
  
  file_path |> 
    read_file() |> 
    str_replace(
      coll("Ryan Seacrest, Katy Perry, Luke Bryan and Lionel Richie as themselves: The host and judges of American Idol.[27]"),
      "Ryan Seacrest as himself (season 2): Host and judge of American Idol\nKaty Perry as herself (season 2): Host and judge of American Idol\nLuke Bryan as himself (season 2): Host and judge of American Idol\nLionel Richie as himself (season 2): Host and judge of American Idol"
    ) |> 
    str_replace(
      coll("The cast of Game Changer (Anna Garcia, Vic Michaelis, Zac Oyama, Sam Reich, and Jacob Wysocki) as themselves"),
      "Anna Garcia as herself (season 8): Host of Game Changer (game show)\nVic Michaelis as himself (season 8): Host of Game Changer (game show)\nZac Oyama as himself (season 8): Host of Game Changer (game show)\nSam Reich as himself (season 8): Host of Game Changer (game show)\nJacob Wysocki as himself (season 8): Host of Game Changer (game show)"
    ) |> 
    str_split("\n") |> 
    unlist() |> 
    tibble(text = _) |> 
    mutate(
      actor = text |> str_extract("^[A-Z][a-z]+\\s[A-Z][a-z]+"),
      character = case_when(
        str_detect(text, "self") ~ actor,
        TRUE ~ str_extract(text, "(?<=\\sas\\s).+(?=\\s\\()")
      ),
      alias = character |> str_extract("(?<=\").+(?=\")"),
      character = character |> str_remove("\".+\"\\s"),
      season = text |> 
        str_extract("(?<=seasons?\\s).+?(?=\\))") |> 
        str_replace_all("present", "8") |> 
        str_replace_all("–", ":"),
      season = season |> 
        str_replace_all("\\d+\\:\\d+", \(x) str_range_to_num_range(x, ",")),
      .before = text
    ) |> 
    separate_wider_delim(
      character,
      delim = " ",
      names = c("first_name", "last_name")
    ) |>
    separate_longer_delim(season, ",") |>
    mutate(
      season = season |> as.integer(),
      across(ends_with("name"), str_to_upper)
    ) |>
    select(-text) |> 
    relocate(c(alias, actor), .after = season)
  
}
