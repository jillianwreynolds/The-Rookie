#' Split transcripts into lines
#'
#' Splits transcripts into lines at `\n`.
#' @param tbl 
#'
#' @returns
#' @export
#'
#' @examples
split_transcripts <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = html |> 
        str_split("\n")
    ) |> 
    unnest(transcript) |> 
    filter_out(transcript == "")
  
}
