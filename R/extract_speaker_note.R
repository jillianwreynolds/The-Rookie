extract_speaker_note <- function(tbl) {
  
  tbl |> 
    mutate(
      # extract from speaker name
      speaker_note = speaker |> str_extract("(?<=[\\[|\\(]).+(?=[\\]|\\)]$)"),
      speaker = speaker |> str_remove("\\s[\\[|\\(].+[\\]|\\)]$")
    ) |> 
    relocate(speaker_note, .after = speaker)
  
}
