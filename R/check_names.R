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
check_names <- function(
    tbl, 
    pattern, 
    peek = TRUE, 
    show_speaker_part_cols = FALSE, 
    print_inf = TRUE
) {
  
  if (!str_detect(pattern, "Ma?c[A-Z]") && str_detect(pattern, "[a-z]")) {
    pattern <- pattern |> str_to_upper()
  }
  
  print_tibble <- tbl |> check_name_variations(pattern)
  
  if (print_inf) {
    print_tibble |> print_inf()
  } else {
    print_tibble |> print()
  }
  
  selected_cols <- c("ep_ID", "speaker", "transcript")
  
  if (show_speaker_part_cols) {
    selected_cols <- selected_cols |> c("sp1", "sp2", "sp3", "sp4")
  }
  
  if (peek) {
    tbl |> 
      select(all_of(selected_cols)) |> 
      collect() |> 
      peek_rows(speaker, pattern)
  } else {
    n_rows <- tbl |> 
      select(all_of(selected_cols)) |> 
      collect() |> 
      peek_rows(speaker, pattern, fmt = "t") |> 
      dim() %>% .[[1]]
    message(glue("{n_rows} rows in the peek_rows() table"))
  }
  
}
