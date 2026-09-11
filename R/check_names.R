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
#' df_raw |> check_names("WESLEY")
#' df_raw |> check_names("JOHN", FALSE)
#' }
check_names <- function(tbl, pattern, peek = TRUE, print_inf = TRUE) {
  
  print_tibble <- tbl |> check_name_variations(pattern)
  
  if (print_inf) {
    print_tibble |> print_inf()
  } else {
    print_tibble |> print()
  }
    
  if (peek) {
    tbl |> 
      select(ep_ID, speaker, transcript) |> 
      collect() |> 
      peek_rows(speaker, pattern)
  } else {
    n_rows <- tbl |> 
      select(ep_ID, speaker, transcript) |> 
      collect() |> 
      peek_rows(speaker, pattern, fmt = "t") |> 
      dim() %>% .[[1]]
    message(glue("{n_rows} rows in the peek_rows table()"))
  }
  
}
