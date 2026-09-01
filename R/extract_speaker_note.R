extract_speaker_note <- function(tbl) {
  
  tbl |> 
    mutate(
      # extract from speaker name
      speaker_note = speaker |> str_extract("(?<=[\\[|\\(]).+(?=[\\]|\\)]$)"),
      speaker = speaker |> str_remove("\\s[\\[|\\(].+[\\]|\\)]$"),
      #extract from transcript column
      # speaker_note = speaker_note |> replace_when(
      #   when_all(is.na(speaker_note), str_detect(transcript, "^(\\(|\\[)")) ~ 
      #   transcript |> str_extract("(?<=[\\[|\\(]).+(?=[\\]|\\)])")
      # ) #,
      # transcript = transcript |> replace_when(
      #   str_equal(
      #     speaker_note,
      #     str_extract(transcript, "(?<=[\\[|\\(]).+(?=[\\]|\\)])")
      #   ) ~ transcript |> str_remove("[\\[|\\(].+[\\]|\\)]\\s")
      # )
      # transcript = transcript |> replace_when(
      #   when_all(
      #     !is.na(speaker_note),
      #     str_detect(transcript, "^(\\(|\\[)"),
      #     str_detect(transcript, "(?<=[\\[|\\(])sing*(?=[\\]|\\)])")
      #   ) ~ transcript |> str_remove("[\\[|\\(].+[\\]|\\)]\\s")
      # )
    )
  
}
