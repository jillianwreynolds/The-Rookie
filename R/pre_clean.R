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
        # remove smart quotes and line separators
        str_replace_all("(\u201c|\u201d)", "\"") |>
        str_replace_all("\u2018|\u2019", "'") |>
        str_remove_all("\u2028") |> 
        # remove title block info
        str_remove(                   
          "^(THE\\sROOKIE[\\s\\S]+?\"[^\"\\n]+\"[^\\S\\n]*\\n+|[\\s\\n]+)"
        ) |> 
        str_remove(
          "^(THE\\sROOKIE[\\s\\S]+?\"[^\"\\n]+\"[^\\S\\n]*\\n+|[\\s\\n]+)"
        ) |> 
        
        # add/remove/rearrange speaker info
        str_replace( # 1x2
          coll("ANNOUNCER\nPreviously on \"The Rookie\""),
          "Previously on the \"The Rookie\""
        ) |> 
        str_replace( # 2x18
          coll("[ Gunshots, people screaming ]\nHelp us! He's got a gun!"),
          "[ Gunshots, people screaming ]\nWOMAN\nHelp us! He's got a gun!"
        ) |> 
        str_replace( # 4x12
          coll("[ Kai singing low in Italian ]"),
          "KAI (singing low in Italian)"
        ) |> 
        
        # capitalization
        str_replace_all(coll("OLIVIA's MOM"), "OLIVIA'S MOM") |>  # 5x19
        
        # typos
        str_replace( # 1x12
          coll("NOLAND and BEN are putting away the party."),
          "NOLAN and BEN are putting away the party."
        ) |> 
        str_replace(coll("La gente pa♪a"), "La gente paga") |>  # 4x12
        str_replace( # 5x19
          coll("NOLAND and BAILEY are sitting on the sofa."),
          "NOLAN and BAILEY are sitting on the sofa."
        ) |> 
        str_replace( # 8x10
          coll("barricaded inside a bulding"),
          "barricaded inside a building"
        ) |> 
        
        # punctuation
        str_replace( # 1x1
          coll("[SIREN CHIRPS] - [KNOCK ON DOOR]"),
          "[SIREN CHIRPS] [KNOCK ON DOOR]"
        ) |> 
        str_replace( # 5x11
          coll("(Kyra finally lays down the weapon)."),
          "(Kyra finally lays down the weapon)"
        ) |> 
        str_replace( # 8x15
          coll("cast of</i>Game Changer<i>are trying"),
          "cast of \"Game Changer\" are trying"
        )
    )
  
}
