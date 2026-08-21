#' Peek at text before and after a match
#'
#' @param string A string.
#' @param pattern A pattern to match.
#' @param before The number of characters to show before the match.
#' @param after The number of characters to show after the match.
#'
#' @returns 
#' @export
#'
#' @examples
peek_match <- function(string, pattern, before = 50, after = 50) {
  string |>
    str_extract_all(
      str_c("(?s).{0,", before, "}", pattern, ".{0,", after, "}")
    ) |>
    unlist() |>
    str_replace_all(pattern, \(m) str_c("\033[0;102m", m, "\033[0m")) |>
    walk(cat)
}

#' Peek at rows before and after a match
#'
#' See the lines before and after a pattern match.
#' @param tbl A tibble or Arrow object.
#' @param col The column where the match is located.
#' @param pattern The pattern to match.
#' @param before The number of lines before a match to be shown.
#' @param after The number of lines after a match to be shown.
#' 
#' @returns A tibble.
#' @export
#' 
#' @examples
#' transcripts_clean |> peek_rows(transcript, "CDC MEDIC")
#' 
peek_rows <- function(tbl, col, pattern, before = 2, after = 2, show_col) {
  
  if (inherits(tbl, "ArrowObject")) {
    tbl <- tbl |> collect()
  }
  
  col <- enquo(col)
  show_col <- enquo(show_col)
  
  hits <- tbl |>
    mutate(.row = row_number()) |>
    filter(str_detect(!!col, pattern)) |>
    pull(.row)
  
  context_rows <- hits |>
    map(\(i) seq(max(1, i - before), min(nrow(tbl), i + after))) |>
    unlist() |>
    unique() |>
    sort()
  
  out <- tbl |>
    mutate(.row = row_number()) |>
    slice(context_rows) |>
    mutate(
      .match = .row %in% hits
    ) 
  
  if (!quo_is_missing(show_col)) {
    out <- out |> select(!!show_col)
  }
  
  out |> 
    gt() |> 
    tab_style(
      style = cell_text(color = "black"),
      locations = list(cells_column_spanners(), cells_body())
    ) |> 
    tab_style_body(
      style = cell_fill(color = "#ADFF2F50"),
      pattern = pattern
    )

}
