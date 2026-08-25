#' Pre-split cleaning
#'
#' String cleaning that needs to go before transcripts are split into lines with `transcripts_to_lines()`.
#' @param tbl A table of un-split transcripts.
#'
#' @returns A tibble with modified transcript strings.
#' @export
#'
#' @examples
#' transcripts |> 
#'   pre_split_clean() |> 
#'   transcripts_to_lines()
pre_split_clean <- function(tbl) {
  
  tbl |> 
    mutate(
      html = html |> 
        # replace "♪ / ♪" with "♪" for separate_longer in clean_transcripts()
        str_replace_all("\u266a\\s/\\s\u266a", "\u266a") |> 
        # manual fixes
        str_replace(
          coll("[ Gunshots, people screaming ]\nHelp us! He's got a gun!"),
          "[ Gunshots, people screaming ]\nWOMAN\nHelp us! He's got a gun!"
        ) |> 
        str_replace(
          coll("NOLAND and BEN are putting away the party."),
          "NOLAN and BEN are putting away the party."
        ) |> 
        str_replace(
          coll("NOLAND and BAILEY are sitting on the sofa."),
          "NOLAN and BAILEY are sitting on the sofa."
        ) |> 
        str_replace(
          coll("ANNOUNCER\nPreviously on \"The Rookie\""),
          "Previously on the \"The Rookie\""
        )
    )
  
}
