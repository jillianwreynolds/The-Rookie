unitalicize_descriptions2 <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = if_else(
        type == "italics",
        transcript |> 
          str_replace_all(coll("</i>."), ".</i>") |> 
          str_replace_all("<i>", "[") |> 
          str_replace_all("</i>", "]"),
        transcript
      ),
      type = if_else(
        str_detect(transcript, "^\\["),
        "description",
        type
      )
    )
  
}
