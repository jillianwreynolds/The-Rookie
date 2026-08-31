#' Identify and clean scene headings
#'
#' @param tbl A table with each episode's transcript split into lines.
#'
#' @returns
#' @export
#'
#' @examples
clean_scene_headings <- function(tbl) {
  
  other_scene_headings <- c(
    "CLIPS FROM SEASON 1, EPISODE 20, \"FREE FALL\" ",
    "PAYNE'S HOUSE - NIGHT",
    "AERIAL VIEW OF CARAVAN ESCORTED BY 2 POLICE UNITS",
    "OUTSIDE, TRAILER PARK",
    "LOPEZ/EVERS HOME, NIGHT - BEDROOM",
    "CEMETERY, DAY - REBECCA ARMSTRONG'S GRAVESITE",
    "RESIDENTIAL STREET, DAY",
    "NEWS CLIP - DECEMBER 5, 2022, COAST GUARD SEARCH FOR MISSING OFFICER",
    "VIDEO CALL WITH INTERVIEWER, ABIGAIL, JENSEN ACKLES, JARED PADALECKI"
  )
  
  tbl |> 
    mutate(
      type = case_when(
        str_detect(transcript, "(INT|EXT)(\\.|,)")       ~ "scene_heading",
        str_detect(transcript, "^(INT|EXT)(\\.|,|\\s)")  ~ "scene_heading",
        str_detect(transcript, "PATROL\\sCAR")           ~ "scene_heading",
        transcript %in% other_scene_headings             ~ "scene_heading",
        str_detect(transcript, "MID-WILSHIRE\\sSTATION") ~ "scene_heading"
      ),
      # Remove parentheses from patrol car scene headings in 4x8
      transcript = if_else(
        str_detect(transcript, "^EXT.+PATROL\\sCAR\\s\\([A-Z]+/[A-Z]+\\)"),
        transcript |> str_replace("\\s\\(", ", ") |> 
          str_remove("\\)$"),
        transcript
      )
    )
}
