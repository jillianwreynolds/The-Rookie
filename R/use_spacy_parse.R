use_spacy_parse <- function(data) {
  
  data |> 
    filter(type == "dialogue") |> 
    mutate(
      row = row_number(),
      doc_id = str_c(ep_ID, "_line", line, "_row", row)
    ) |> 
    rename(text = transcript) |> 
    spacy_parse(dependency = TRUE, nounphrase = TRUE) |> 
    separate_wider_delim(
      doc_id, "_", names = c("ep_ID", "line", "row"), cols_remove = FALSE
    ) |>
    separate_wider_delim(
      ep_ID, "x", names = c("season", "episode"), cols_remove = FALSE
    ) |> 
    mutate(
      line = line |> str_remove("line"),
      row = row |> str_remove("row")
    ) |> 
    relocate(ep_ID)

}
