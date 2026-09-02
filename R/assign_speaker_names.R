assign_speaker_names <- function(tbl) {
 
  speaker_name_patterns <- c(
    "^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+$",
    "^ACTOR![A-Z]+$",
    "^[A-Z][a-z]{1,2}[A-Z]+$",
    # identifies speakers whose name is followed by () description
    "^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+\\s[\\[|\\(].+[\\]|\\)]$",
    # multi-speaker names separated by "and"
    "^[A-Z\']+\\sand\\s[A-Z]+\\s?[A-Z]+$"
  ) |> 
    str_flatten(collapse = "|")
  
  not_speaker_patterns <- c(
    "^OK",
    "^LAP-$",
    "^LAPD[\\.!,]?$",
    all_caps_pattern,
    "^\\d[\\d\\s,\\-]*\\.?$",  # numbers, list or including dash(es)
    "^8977\\.",
    "^R-2\\.$",
    stutter_cutoff_letters_pattern
  ) |> 
    str_flatten(collapse = "|")
  
  tbl |> 
    mutate(
      is_speaker = if_else(
        is.na(type),
        str_detect(transcript, speaker_name_patterns) &
          !str_detect(transcript, not_speaker_patterns),
        FALSE
      ),
      type = type |> replace_when(str_detect(transcript, "^<i>") ~ "italics"),
      is_break = is_speaker | !is.na(type),
      group_id = cumsum(is_break),
      .by = c(season, episode)
    ) |>
    summarise(
      speaker = first(transcript[is_speaker] |> str_trim()),
      transcript = transcript[!is_speaker] |> str_flatten(collapse = " "),
      type = first(type),
      .by = c(season, episode, group_id)
    ) |> 
    mutate(
      type = replace_when(type, !is.na(speaker) ~ "dialogue"),
      line = row_number(),
      .by = c(season, episode)
    ) |>
    select(-group_id) |>
    relocate(c(line, type), .after = episode)
   
}
