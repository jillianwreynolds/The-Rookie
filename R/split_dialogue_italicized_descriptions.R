#' Split dialogue rows with italicized description
#'
#' When rows are `type == "dialogue"` and contain italicized description between parts of a character's dialogue, this function places sentinels before `"<i>\\("` and after `")<i>"` then separates lines at sentinels. It then updates `type` and `speaker`. The replacement checks for parentheses because some dialogue rows have italicized dialogue.
#' @param tbl A data frame.
#'
#' @returns
#' @export
#'
#' @examples
split_dialogue_italicized_descriptions <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = if_else(
        when_all(
          str_starts(type, "dialogue"),
          str_detect(transcript, "</?i>")
        ),
        transcript |> 
          str_replace_all("\\s(?=<i>\\()", "\u2757") |>
          str_replace_all("(?<=\\)</i>)\\s", "\u2757"),
        transcript
      )
    ) |> 
    separate_longer_delim(transcript, "\u2757") |> 
    mutate(
      type = type |> replace_when(
        when_all(type == "dialogue", str_starts(transcript, "<i>")) ~ "italics"
      ),
      speaker = speaker |> replace_when(
        when_all(
          type == "dialogue", str_starts(transcript, "<i>")
        ) ~ NA_character_
      )
    )
  
}
