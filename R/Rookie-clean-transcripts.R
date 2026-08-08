clean_transcripts <- function(tbl) {
  tbl |> 
    mutate(
      transcript = str_remove_all(transcript, "\\s*[-–]?\\s*\\[[^]]+\\]\\s*[-–]?\\s*\n*") |>
        str_remove_all("\\s*[-–]?\\s*\\([^)]+\\)\\s*[-–]?\\s*\n*") |>
        str_replace_all("\n{3,}", "\n\n") |> 
        str_split("\n\n")
    ) |> 
    unnest(transcript) |> 
    mutate(
      transcript = str_remove(transcript, "^[\\s\\-–]*"),
      rowID = row_number(),
      type = case_when(
        str_detect(transcript, "(INT|EXT)\\.") ~ 
          "scene_heading",
        str_detect(transcript, "[A-Z]+[:punct:]*[A-Z]+$") ~ "caption",
        str_detect(
          transcript,
          "^[A-Z][A-Z]+(?:[,/]\\s*[A-Z]+|\\sand\\s[A-Z]+)+(?=\"|[A-Z\\d]{1}[a-z\\d\'\\s-]+)"
        ) ~ "dialogue_multi_speaker",
        str_detect(
          transcript, "^[A-Z][A-Z\\s]+(?=\"|[A-Z\\d]{1}[a-z\\d\'\\s-]+)"
        ) ~ "dialogue",
        TRUE ~ "other"
      ),
      speaker = if_else(
        type == "dialogue" | type == "dialogue_multi_speaker",
        str_extract(
          transcript,
          "^[A-Z][A-Z\\s,/\\.]+(?:\\sand\\s[A-Z]+)*(?=\"|[A-Z\\d\"]{1}[a-z\\d\'\\s-]+)"
        ),
        NA_character_
      ),
      scene = case_when(
        type == "scene_heading" & str_detect(transcript, "EXT\\.") ~ "EXT",
        type == "scene_heading" & str_detect(transcript, "INT\\.") ~ "INT"
      )
    ) |> 
    separate_longer_delim(speaker, delim = regex("(,\\s|\\sand\\s|/)"))

}
