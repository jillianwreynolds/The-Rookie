reclassify_type <- function(tbl) {
  
  tbl |> 
    mutate(
      type = if_else(
        str_detect(transcript, "^[\\[\\(]"),
        "description",
        type
      ),
      type = if_else(
        when_all(
          type == "italics",
          str_detect(transcript, "^[A-Z0-9\"]")
        ),
        "dialogue",
        type
      ),
      dialogue_type = case_when(
        str_detect(transcript, "\u266a") ~ "lyrics"
      )
    )
  
}
