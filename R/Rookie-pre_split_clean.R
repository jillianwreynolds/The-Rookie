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
      html = html |> str_replace(
        coll("[ Gunshots, people screaming ]\nHelp us! He's got a gun!"),
        "[ Gunshots, people screaming ]\nWOMAN\nHelp us! He's got a gun!"
      )
    )
  
}
