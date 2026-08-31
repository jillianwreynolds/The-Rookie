#' Manual text cleaning
#'
#' Manual text cleaning that enables or improves text data for further cleaning.
#' @param tbl A table with each episode's transcript as a single string.
#'
#' @returns
#' @export
#'
#' @examples
pre_clean <- function(tbl) {
  
  tbl |> 
    mutate(
      html = html |> 
        # add/remove/rearrange speaker info
        str_replace(
          coll("ANNOUNCER\nPreviously on \"The Rookie\""),
          "Previously on the \"The Rookie\""
        ) |> 
        str_replace(
          coll("[ Kai singing low in Italian ]"),
          "KAI (singing low in Italian)"
        ) |> 
        str_replace(
          coll("[ Gunshots, people screaming ]\nHelp us! He's got a gun!"),
          "[ Gunshots, people screaming ]\nWOMAN\nHelp us! He's got a gun!"
        ) |> 
        
        # typos
        str_replace(coll("La gente pa♪a"), "La gente paga") |> 
        str_replace(
          coll("NOLAND and BEN are putting away the party."),
          "NOLAN and BEN are putting away the party."
        ) |> 
        str_replace(
          coll("NOLAND and BAILEY are sitting on the sofa."),
          "NOLAN and BAILEY are sitting on the sofa."
        ) |> 
        
        # punctuation
        str_replace(
          coll("[SIREN CHIRPS] - [KNOCK ON DOOR]"),
          "[SIREN CHIRPS] [KNOCK ON DOOR]"
        ) |> 
        str_replace(
          coll("(Kyra finally lays down the weapon)."),
          "(Kyra finally lays down the weapon)"
        )
    )
  
}
