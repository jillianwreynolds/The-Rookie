#' Filters for main characters
#'
#' This function filters for main characters by identifying instances where the character's name appears as first and last name or when only their last name is used. This should exclude instances like "Henry Nolan" and "Mrs. Chen."
#' @param tbl A table to filter. Main characters are defined in a tibble called `main_chars`, defined in `R/Rookie-vars.R`.
#'
#' @returns
#' @export
#'
#' @examples
#' transcripts_clean |> 
#'   select(season, episode, type, speaker_start, speaker_end, transcript) |> 
#'   filter_main_chars() |> 
#'   group_by(season) |> 
#'   count(speaker_end)
filter_main_chars <- function(tbl) {
  
  tbl |> 
    filter(when_any(
      speaker_start %in% main_chars$first_name & 
        speaker_end %in% main_chars$last_name,
      is.na(speaker_start) & speaker_end %in% main_chars$last_name
    ))
  
}
