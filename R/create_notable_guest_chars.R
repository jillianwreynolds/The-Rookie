create_notable_guest_chars <- function(file_path) {
  
  file_path |> 
    read_file() |> 
    str_remove_all("\\[.+?\\]") |> 
    str_split("\n") |> 
    unlist() |> 
    tibble(text = _) |> 
    filter_out(str_detect(text, coll("as Jake Butler and Sava Wu"))) |> 
    mutate(
      actor = text |> str_extract(".+?(?=\\sas\\s)"),
      character = case_when(
        str_detect(text, "as\\s(her|him)self") ~ actor
      ),
      character = if_else(
        is.na(character),
        text |> str_extract("(?<=\\sas\\s).+(?=[:])"),
        character
      ),
      character = character |> str_replace(
        coll("Jeffrey Boyle / Eli Reynolds"),
        "Eli Reynolds / Jeffrey Boyle"
      ),
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
    separate_wider_delim(
      character,
      delim = " ",
      names = c("char_title", "first_name", "last_name"),
      too_few = "align_end"
    ) |>
    select(-text)
  
}
