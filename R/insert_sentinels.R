insert_sentinels <- function(
    tbl, multiple_symbols = TRUE, symbol = red_circle
) {
  
  symbols_list <- c(
    # non-italics lines
    red_circle, red_loop, red_cross,
    # italics lines
    blue_square,
    blue_circle, purple_circle,
    blue_diamond, red_square, orange_diamond
  )
  
  tbl <- tbl |> 
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
  
  if (multiple_symbols == TRUE) {
    tbl
  } else {
    tbl |> 
      mutate(
        transcript = reduce(symbols_list, \(acc, s) {
          str_replace_all(acc, s, symbol)
        }, .init = transcript)
      )
  }
  
}
