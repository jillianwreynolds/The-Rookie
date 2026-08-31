extract_speaker_note <- function(tbl) {
  
  tbl |> 
    mutate(
      speaker_note = speaker |> str_extract("(?<=[\\[|\\(]).+(?=[\\]|\\)]$)"),
      speaker = speaker |> str_remove("\\s[\\[|\\(].+[\\]|\\)]$"),
      speaker_note = speaker_note |> replace_when(
        when_all(is.na(speaker_note), str_detect(transcript, "^(\\(|\\[)")) ~ 
        transcript |> str_extract("(?<=[\\[|\\(]).+(?=[\\]|\\)])")
      ),
      transcript = transcript |> replace_when(
        when_all(is.na(speaker_note), str_detect(transcript, "^(\\(|\\[)")) ~ 
          transcript |> str_extract("([\\[|\\(]).+(?=[\\]|\\)])")
      )
    )
  
}
