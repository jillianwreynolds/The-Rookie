#' Remove colon and space separating names and dialogue
#'
#' Where names are separated from dialogue by a colon and space, this function replaces the colon and space with a new line so that speaker name and dialogue are on separate lines after `transcripts_to_lines()`.
#' @param tbl A table with column `html` and each episode's transcript is a single string.
#'
#' @returns
#' @export
#'
#' @examples
clean_speaker_names <- function(tbl) {
  
  tbl |> 
    mutate(
      html = html |> 
        # replace [] with () for easier speaker_note extraction
        str_replace_all("\\[V\\.O\\.\\]", "(V.O.)") |>
        #
        str_replace_all(coll("(on TV) Bobby: "), "BOBBY (on TV)\n") |>    # 3x6
        str_replace(coll("Man: Don't move."), "MAN\nDon't move.") |>      # 4x13
        str_replace(coll("Man #2: Clear!"), "MAN #2\nClear!") |>          # 4x13
        str_replace(coll("Woman: Hear, hear."), "WOMAN\nHear, hear.") |>  # 4x18
        str_replace_all(coll("Operator: "), "OPERATOR\n") |>              # 7x15
        str_replace_all(coll("Caller: "), "CALLER\n") |> 
        str_replace(coll("BRADFORD/CHEN: Yeah"), "BRADFORD/CHEN\nYeah") |># 8x4
        # 1x15
        str_replace( 
          coll("BRADFORD You think it's a bad idea"),
          "BRADFORD\nYou think it's a bad idea"
        ) |> 
        # 2x6
        str_replace( 
          coll("CHEN Hey! Hands on the hood"),
          "CHEN\nHey! Hands on the hood"
        ) |> 
        str_replace(
          coll("NICKERSON Now. Come on"),
          "NICKERSON\nNow. Come on"
        ) |> 
        # 7x14
        str_replace_all("V/O", "VOICEOVER")
    )
}
