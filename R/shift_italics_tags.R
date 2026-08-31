#' Shift incorrectly placed italics tags
#'
#' @param tbl A table with each episode's transcripts split into lines.
#'
#' @returns
#' @export
#'
#' @examples
shift_italics_tags <- function(tbl) {
 
  tbl |> 
    mutate(
      # Move <i> from middle to beginning of word
      transcript = transcript |> str_replace_all("(\\w+)<i>", "<i>\\1"),
      # If "<i>(", Move </i> inside parentheses to outside parentheses
      transcript = if_else(
        str_detect(transcript, "<i>\\("),
        str_replace_all(transcript, "</i>\\)", "\\)</i>"),
        transcript
      )
    )
   
}
