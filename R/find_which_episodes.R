#' Find episodes for which a character has a line
#'
#' This function will filter for rows matching the `name_pattern` and return a tibble indicating which episodes the character spoke at least one word.
#' @param tbl 
#' @param name_pattern A regex to pass to `str_detect()`.
#'
#' @returns
#' @export
#'
#' @examples
#' \dontrun{
#' df_raw |> find_episodes("RANDY")
#' }
find_which_episodes <- function(tbl = df_raw, name_pattern) {
  
  tbl |> 
    select(season, episode, type, speaker) |> 
    filter(type == "dialogue", str_detect(speaker, name_pattern)) |> 
    collect() |> 
    distinct(season, episode)
  
}
