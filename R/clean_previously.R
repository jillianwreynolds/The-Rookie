#' Clean "Previously on..." lines
#'
#' Identifies "Previously on..." lines and cleans text for consistency.
#' @param tbl A table with each episode's transcripts split into lines.
#'
#' @returns
#' @export
#'
#' @examples
clean_previously <- function(tbl) {
  
  tbl |> 
    mutate(
      type = case_when(
        str_detect(transcript, "Previously") &
          str_detect(transcript, "(?i)Rookie")           ~ "previously"
      ),
      transcript = transcript |> replace_when(
        type == "previously" & !str_detect(transcript, "Feds") 
        ~ "Previously on \"The Rookie\"",
        type == "previously" & str_detect(transcript, "Feds") 
        ~ "Previously on \"The Rookie\" and \"The Rookie: Feds\""
      )
    ) |> 
    relocate(type, .before = transcript)
  
}
