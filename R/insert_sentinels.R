insert_sentinels <- function(tbl) {
  
  tbl |> 
    mutate(
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
