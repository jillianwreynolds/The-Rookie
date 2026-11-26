separate_ep_ID_col <- function(data) {
  
  data |> separate_wider_delim(
    ep_ID, "x", names = c("season", "episode"), cols_remove = FALSE
  )
  
}
