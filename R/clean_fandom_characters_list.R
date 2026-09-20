clean_fandom_characters_list <- function(file_path = "data/fandom-characters-list.txt") {
  
  file_path |> 
    read_file() |> 
    str_remove("Senator ") |> 
    str_split("\n") |> 
    tibble(names = _) |> 
    unnest(names) |> 
    filter_out(when_any(
      names == "",
      str_detect(names, "Officer Smitty"), # NYPD version of Smitty
      str_detect(names, "fictional"),
      str_detect(names, "List of"),
      str_detect(names, "characters"),
    )) |> 
    mutate(
      n_words = names |> str_count(" ") + 1,
      names = names |> str_remove(" \\(.+\\)")
    )
  
}
