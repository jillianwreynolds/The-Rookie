insert_sentinels <- function(tbl) {
  
  tbl |> 
    mutate(
      # when type isn't italics and () or [] don't appear at both start and end
      transcript = if_else(
        when_all(
          type != "italics",
          str_detect(transcript, "^[^(\\(|\\[)]"),
          str_detect(transcript, "[^(\\)|\\])]$")
        ),
        str_replace_all(transcript, "\\s(?=\\(|\\[)", "\u2757"),
        # str_replace_all(transcript, "(?<=\\)|\\])\\s", "\u2757"),
        transcript,
      )
    )
  
}
