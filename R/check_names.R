#' Check name variations and peek at transcript
#'
#' @param tbl A table in which tokens have not been unnested.
#' @param pattern A pattern to pass to `check_name_variations()` and `peek_rows()`. 
#'
#' @returns
#' @export
#'
#' @examples
#' \dontrun{
#' df_raw |> check_names("JOHN\\b")
#' }
check_names <- function(tbl, pattern) {
  
  if (!str_detect(pattern, "Ma?c[A-Z]") && str_detect(pattern, "[a-z]")) {
    pattern <- pattern |> str_to_upper()
  }
  
  tbl |> check_name_variations(pattern) |> print()
  
  tbl |> 
    select(ep_ID, speaker, transcript) |> 
    collect() |> 
    peek_rows(speaker, pattern)
  
}
