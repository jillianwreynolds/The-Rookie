#' Split dialogue from "italics" rows
#'
#' When rows are `type == "italics"` but have dialogue after italics, this function inserts a sentinel at the `\\s` boundary and separates the lines at the sentinel. It then updates `type` and `speaker`. Whether dialogue follows is determined by whether the character following `"</i>\\s"` is a capital letter. Speaker is determined by a temporary down-filled `last_dialogue_speaker` column.
#' @param tbl A data frame.
#'
#' @returns
#' @export
#'
#' @examples
split_italics_dialogue <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = if_else(
        type == "italics",
        transcript |> str_replace_all("(?<=</i>)\\s(?=[A-Z])", "\u270a"),
        transcript
      )
    ) |> 
    separate_longer_delim(transcript, "\u270a")
  
}
