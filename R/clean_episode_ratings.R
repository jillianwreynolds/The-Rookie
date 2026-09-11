clean_episode_ratings <- function(tbl) {
  
  tbl |> 
    rename(
      season = seasonNumber,
      episode = episodeNumber,
      mean_rating = averageRating,
      n_votes = numVotes
    )
  
}
