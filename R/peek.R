peek_match <- function(string, pattern, before = 50, after = 50) {
  string |>
    str_extract_all(
      str_c("(?s).{0,", before, "}", pattern, ".{0,", after, "}")
    ) |>
    unlist() |>
    str_replace_all(pattern, \(m) str_c("\033[0;102m", m, "\033[0m")) |>
    walk(cat)
}
