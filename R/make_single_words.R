make_single_words <- function(tbl) {
  
  tbl |> 
    mutate(
      html = html |> 
        str_replace_all("(?<=(?i)Mid)-(?=(?i)Wilshire)", "_") |> 
        str_replace_all(
          "(\\d)\\-([A-Z][a-z]*)\\-(\\d{1,})",
          paste0("\\1", "_", "\\2", "_", "\\3")
        ) |> 
        str_replace_all("(?<=\\s5)-(?=4\\s)", "_")
    )
  
}
