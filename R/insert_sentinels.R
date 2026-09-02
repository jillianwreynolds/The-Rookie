insert_sentinels <- function(tbl) {
  
  tbl |> 
    mutate(
      # remove duplicate spaces
      transcript = transcript |> str_replace_all("(?<=.)\\s{2}(?=.)", " "),
      
      # when type isn't italics
      transcript = if_else(
        type != "italics",
        transcript |> 
          # 🔴 before [ or (
          str_replace_all("\\s(?=[\\[|\\(])", red_circle) |> 
          # 🔴 after ] or )
          str_replace_all("(?<=[\\]|\\)])\\s", red_circle) |> 
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
          str_replace_all("(?<=[\\]|\\)])\\s(?=[\\[|\\(])", blue_square) |> 
          str_replace_all("(?<=</i>)\\s(?=<i>)", blue_square) |> 
          # 🔵 between </i> and () or [] description
          str_replace_all("(?<=</i>)\\s(?=[\\[|\\(])", blue_circle) |> 
          # 🟣 between </i> and dialogue
          str_replace_all(
            "(?<=[\\.\\!\\?\\)]</i>)\\s(?=[A-Z\\d\"])",
            purple_circle
          ) |> 
          # italics then dialogue then 🔷 before description
          str_replace_all(
            "(?<=</i>)(.+)\\s(?=\\()", paste0("\\1", blue_diamond)
          ) |> 
          # 🟦 between description and description
          str_replace_all("(?<=[\\]|\\)])\\s(?=[\\[|\\(])", blue_square) |> 
          # 🟪 between dialogue and description/italics
          # 🔶 after description (like red_cross)
          str_replace_all(
            "(?<=</i>)(.+[\\]\\)])\\s(?=[A-Z\\d\"])",
            paste0("\\1", orange_diamond)
          ),
        transcript
      )
    )
  
}
