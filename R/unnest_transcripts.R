unnest_transcripts <- function(tbl, token = "words", n = NULL) {
  
  if (token == "words") {
    tbl <- tbl |> unnest_tokens(unnested, transcript, to_lower = FALSE)
  } else {
    tbl <- tbl |> unnest_tokens(
      unnested, transcript, token = token, n = n, to_lower = FALSE
    )
  }
  
  tbl <- tbl |> 
    mutate(word = unnested |> str_to_lower()) |> 
    relocate(c(unnested, word), .after = speaker_note)
  
  if (token == "words") {
    tbl
  } else {
    names_2 <- c("word1", "word2")
    names_3 <- c("word1", "word2", "word3")
    name_vec <- if(n == 2) names_2 else names_3
    tbl |> separate_wider_delim(word, delim = " ", names = name_vec)
  }
  
}
