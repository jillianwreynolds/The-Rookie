clean_episode_ratings <- function(tbl) {
  
  tbl |> 
    rename(
      season = seasonNumber,
      episode = episodeNumber,
      rating = averageRating,
      n_votes = numVotes
    ) |> 
    filter_out(season == 9)
  
}
