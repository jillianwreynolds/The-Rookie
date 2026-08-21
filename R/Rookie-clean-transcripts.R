clean_transcripts <- function(tbl) {
  
  lookahead <- "(?=[\"$♪\'\\.a-z]|[A-Z][\\s-]|\\d(?![-A-Z#]))"
  
  full_pattern <- c(
    str_c("^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+", lookahead),
    str_c("^ACTOR![A-Z]+", lookahead),
    str_c("^[A-Z][a-z]{1,2}[A-Z]+", lookahead)
  ) |> 
    str_flatten(collapse = "|")
  
  tbl |> 
    mutate(
      transcript = transcript |> 
        str_remove_all("\\s*[-–]?\\s*\\[[^]]+\\]\\s*[-–]?\\s*") |>
        str_remove_all("\\s*[-–]?\\s*\\([^)]+\\)\\s*[-–]?\\s*") |>
        str_replace_all("\n{3,}", "\n\n") |> 
        str_replace_all("[^\n]\n{1}(?=[^\n])", "\n\n") |>
        str_replace_all("(\u201c|\u201d)", "\"") |>
        str_replace_all("\u2018|\u2019", "'") |>
        str_remove_all("\u2028") |> 
        # Cleaning needs to go before splitting
        str_split("\n\n")
    ) |> 
    unnest(transcript) |> 
    filter_out(transcript == "") |> 
    mutate(
      rowID = row_number(),
      # remove ":\\s" separating name and dialogue; converts lower to upper
      transcript = transcript |> 
        str_replace("(^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+):\\s", "\\1") |> 
        str_replace(
          "^([A-Z][a-zA-Z0-9\\s#/,]+):\\s",
          \(x) str_remove(str_to_upper(x), ":\\s")
        ),
      # categorize lines by type 
      type = case_when(
        transcript %in% captions ~ "caption",
        str_detect(
          transcript, "Previously\\son\\s(\"?The Rookie\"?|THE\\sROOKIE|\\.{3})"
        ) ~ "other",
        str_detect(transcript, "(INT|EXT)(\\.|,)") ~ "scene_heading",
        str_detect(transcript, "PATROL\\sCAR") ~ "scene_heading",
        str_detect(transcript, "^ACTOR![A-Z]+") ~ "dialogue_recorded",
        str_detect(transcript, all_caps_pattern) ~ "dialogue",
        str_detect(transcript, full_pattern) ~ "dialogue"
      ),
      scene = case_when(
        type == "scene_heading" & str_detect(transcript, "EXT") ~ "EXT",
        type == "scene_heading" & str_detect(transcript, "INT") ~ "INT",
        type == "scene_heading" & 
          str_detect(transcript, "PATROL\\sCAR") ~ "shop"
      )
    ) |> 
    mutate(line = row_number(), .by = c(season, episode), .after = episode)

}
