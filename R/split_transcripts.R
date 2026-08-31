#' Split transcripts into lines
#'
#' Splits transcripts line by line. First replaces smart quotes, removes line separators, and strips title block info. Then splits at transcripts into lines at `\n`.
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
