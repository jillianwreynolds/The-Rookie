#' Split transcripts into lines
#'
#' Splits transcripts line by line. First replaces smart quotes, removes line separators, and strips title block info. Then splits at transcripts into lines at `\n`.
#' @param tbl 
#'
#' @returns
#' @export
#'
#' @examples
transcripts_to_lines <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = html |> 
        str_replace_all("(\u201c|\u201d)", "\"") |>
        str_replace_all("\u2018|\u2019", "'") |>
        str_remove_all("\u2028") |> 
        str_remove(                   # remove title block info
          "^(THE\\sROOKIE[\\s\\S]+?\"[^\"\\n]+\"[^\\S\\n]*\\n+|[\\s\\n]+)"
        ) |> 
        str_remove(
          "^(THE\\sROOKIE[\\s\\S]+?\"[^\"\\n]+\"[^\\S\\n]*\\n+|[\\s\\n]+)"
        ) |> 
        str_split("\n")
    ) |> 
    unnest(transcript) |> 
    filter_out(transcript == "")
  
}
