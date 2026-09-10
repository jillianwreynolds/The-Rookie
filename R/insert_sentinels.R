insert_sentinels <- function(tbl) {
  
  tbl |> 
    mutate(
      # update type
      type = if_else(is.na(type), "description", type),
      
      # remove duplicate spaces
      transcript = transcript |> str_replace_all("(?<=.)\\s{2}(?=.)", " "),
      
      # when type is description or dialogue
      transcript = if_else(
        type %in% c("description", "dialogue"),
        transcript |> 
          # 🔴 before [ or (
          str_replace_all("\\s(?=\\(|\\[)", red_circle) |> 
          # 🔴 after ] or )
          str_replace_all("(?<=\\)|\\])\\s", red_circle) |> 
          # 🟫 between lyrics lines " ♪ ♪ "
          str_replace_all("(?<=\u266a)\\s(?=\u266a)", brown_square) |> 
          # 🟤 between dialogue and lyrics
          str_replace_all("(?<!\\))\\s(?=\u266a\\s)", brown_circle) |> 
          # manually adjust 🟤 when dialogue -> lyrics -> dialogue
          str_replace(coll("sexy🟤♪ It's--it's"), "sexy ♪🟤It's--it's") |> 
          # ⭕ before <i>(
          str_replace_all("\\s(?=<i>\\()", red_loop) |> 
          # ❌ after )</i>
          str_replace_all("(?<=\\)</i>)\\s", red_cross),
        transcript,
      ),
      
      # when type is italics
      transcript = if_else(
        type == "italics",
        transcript |> 
          # 🟦 between description and description
          str_replace_all("(?<=\\)|\\])\\s(?=\\(|\\[])", blue_square) |> 
          str_replace_all("(?<=</i>)\\s(?=<i>)", blue_square) |> 
          # 🔵 between </i> and () or [] description
          str_replace_all("(?<=</i>)\\s(?=\\(|\\[)", blue_circle) |> 
          # 🟣 between </i> and dialogue
          # excludes italicized dialogue by requiring punctuation before </i>
          str_replace_all(
            "(?<=[\\.\\!\\?\\)]</i>)\\s(?=[A-Z\\d\"])",
            purple_circle
          ) |> 
          # 🔷 after italics and dialogue and before description (like red_loop)
          # only () and [] description; not when dialogue is followed by italics
          str_replace_all(
            "(?<=</i>)(.+)\\s(?=\\(|\\[)", paste0("\\1", blue_diamond)
          ) |> 
          # 🟥 between dialogue and italicized description
          str_replace_all("(?<=[\\.\"\\!])\\s(?=<i>)", red_square) |> 
          # 🔶 after description (like red_cross)
          str_replace_all(
            "(?<=</i>)(.+[\\]\\)])\\s(?=[A-Z\\d\"])",
            paste0("\\1", orange_diamond)
          ),
        transcript
      )
    )
  
}
