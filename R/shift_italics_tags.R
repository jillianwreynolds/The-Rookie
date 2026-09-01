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
      ),
      transcript = transcript |> 
        # 2x5
        str_replace(
          coll("<i>JOHN</i> <i>NOLAN is plastering the interior wall"),
          "<i>JOHN NOLAN is plastering the interior wall"
        ) |> 
        str_replace(
          coll("<i>DAISY</i> <i>turns to face CHEN, BRADFORD, and HILDA</i>"),
          "<i>DAISY turns to face CHEN, BRADFORD, and HILDA.</i>"
        ) |> 
        # 2x11
        str_replace(
          coll("<i>JOHN</i> <i>NOLAN's television is on and he's"),
          "<i>JOHN NOLAN's television is on and he's"
        ) |> 
        str_replace(
          coll("<i>As</i> <i>CHEN struggles to break free of her restraints"),
          "<i>As CHEN struggles to break free of her restraints"
        ) |> 
        # 2x15
        str_replace(
          coll("NOLAN <i>climbs up the ladder"),
          "<i>NOLAN climbs up the ladder"
        ) |> 
        str_replace(
          coll("<i>(He sprays the MAN in the face and cuffs him. To NEIL)</i>"),
          "(<i>He sprays the MAN in the face and cuffs him. To NEIL</i>)"
        )
    )
   
}
