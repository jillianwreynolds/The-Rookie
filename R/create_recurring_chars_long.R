create_recurring_chars_long <- function(file_path) {
  
  file_path |>
    read_parquet() |> 
    mutate(
      text = text |> 
        str_replace("Monte(?=: A)", "Monte (seasons 1-8)") |> 
        str_replace("Hutchinson(?=: A)", "Hutchinson (seasons 1-8)") |> 
        str_replace("Smitty(?=: A)", "Smitty (seasons 1-8)"),
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
  
}
