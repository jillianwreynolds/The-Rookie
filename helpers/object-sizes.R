parquet_list <- list(
  episodes = nanoparquet::read_parquet(here::here(
    "transcripts_parquet.parquet"
  )),
  characters = nanoparquet::read_parquet(here::here(
    "characters_parquet.parquet"
  )),
  ratings = nanoparquet::read_parquet(here::here("episode_ratings.parquet")),
  df_raw = nanoparquet::read_parquet(here::here("data/df_raw.parquet"))
)

lobstr::obj_sizes(parquet_list)

lobstr::obj_sizes(!!!parquet_list)
