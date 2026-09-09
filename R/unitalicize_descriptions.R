unitalicize_descriptions <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = if_else(
        when_any(
          str_detect(transcript, blue_circle),
          str_detect(transcript, purple_circle),
          str_detect(transcript, red_loop)
        ),
        transcript |> 
          str_replace_all("<i>\\(", "[") |> 
          str_replace_all("\\)</i>", "]") |> 
          str_replace_all("<i>", "[") |> 
          str_replace_all("</i>", "]"),
        transcript
      )
    )
  
}
