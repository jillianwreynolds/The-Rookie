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
#' transcripts_html$transcript[1] |> peek_match("hotshot")
peek_match <- function(string, pattern, before = 50, after = 50) {
  
  if (!str_detect(string, pattern)) {
    return(message("Pattern not detected in string"))
  }
  
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
#' @param fmt If `gt`, the default, rows are returned as a `gt` table with matches highlighted. If `fmt = "tbl"`, rows are returned as a tibble.
#' 
#' @returns A tibble.
#' @export
#' 
#' @examples
#' transcripts_clean |> peek_rows(transcript, "CDC MEDIC")
#' transcripts_clean |> peek_rows(transcript, "CDC MEDIC", fmt = "tbl)
#' 
peek_rows <- function(tbl, col, pattern, show_col, before = 2, after = 2, fmt = "gt") {
  
  fmt <- match.arg(fmt, c("gt", "tbl"))
  
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
  
  if (fmt == "gt") {
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
  } else {
    out
  }
  

}

#' Peek at first and last lines of episodes
#'
#' @param tbl A tibble or ArrowObject with transcripts split into lines.
#' @param first The number of lines at the beginning of each episode to show.
#' @param last The number of lines from the end of each episode to show.
#'
#' @returns A tibble showing some number of the first and/or the last lines of episodes.
#' @export
#'
#' @examples
peek_first_last_lines <- function(tbl, first = 2, last = 2) {
  
  selected <- tbl |> select(season, episode, line, transcript)
  
  if (inherits(tbl, "ArrowObject")) {
    out <- selected |> 
      collect() |> 
      group_by(season, episode)
  }
  
  if (last == 0) {
    out |> filter(line %in% c(1:first))
  } else {
    out |> filter(line %in% c(1:first, (max(line) - (last - 1)):max(line)))
  }
  
}
