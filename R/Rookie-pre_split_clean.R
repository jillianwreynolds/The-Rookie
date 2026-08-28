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
        # other fixes
        str_replace_all(coll("]["), "] [") |> 
        str_replace(
          coll("ANNOUNCER\nPreviously on \"The Rookie\""),
          "Previously on the \"The Rookie\""
        ) |> 
        str_replace(
          coll("[ Kai singing low in Italian ]"),
          "KAI (singing low in Italian)"
        ) |> 
        str_replace(coll("La gente pa♪a"), "La gente paga") |> 
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
          coll("[SIREN CHIRPS] - [KNOCK ON DOOR]"),
          "[SIREN CHIRPS] [KNOCK ON DOOR]"
        ) |> 
        str_replace(
          coll("[ laughing ]Lighten"),
          "[ laughing ] Lighten"
        ) |> 
        str_replace(
          coll("(Kyra finally lays down the weapon)."),
          "(Kyra finally lays down the weapon)"
        ) |> 
        str_replace(
          coll("Corey screams, glass breaking ]  Breathing"),
          "Corey screams, glass breaking ] [Breathing"
        ) |> 
        str_replace(coll("Dial tone ]"), "[ Dial tone ]") |> 
        str_replace(coll("BYSTANDER(on video)"), "BYSTANDER (on video)")
    )
  
}
