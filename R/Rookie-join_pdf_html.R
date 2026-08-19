#' Title
#'
#' Join pdf and html transcripts; extract season, episode, title. Number episodes and create ep_ID
#' @param df_pdf 
#' @param df_html 
#'
join_pdf_html <- function(df_pdf, df_html) {
  
  df_pdf |> 
    mutate(
      season = str_extract(
        transcript, "(?<=THE\\sROOKIE\n(Season|SEASON)\\s)\\d+"
      ),
      episode = str_extract(
        transcript, "(?<=(Season|SEASON)\\s\\d,\\s(E|e)pisode\\s)\\d+"
      ),
      title = str_extract(
        transcript, "^[\\s\\S]+?(?=(/Transcript|\\s(T|t)ranscript))"
      ) |> 
        str_remove_all("\"") |> 
        str_replace_all("\\s+", " ") |>
        str_trim()
      ,
      .before = transcript
    ) |> 
    mutate(
      transcript = str_remove(transcript, "^[\\s\\S]+?\n\n"),
      season = as.integer(season),
      episode = as.integer(episode)
    ) |> 
    arrange(season, episode) |> 
    mutate(
      episode_number = row_number(), 
      ep_ID = str_c(season, episode, sep = "x"),
      .before = season
    ) |> 
    left_join(df_html, by = join_by(title)) |> 
    rename(pdf = transcript.x, html = transcript.y) |> 
    mutate(
      transcript = str_remove_all(html, "<i>[\\s\\S]+?</i>") |> 
        str_remove_all("\\([^)]+\\)") |>
        str_remove_all("\\[[^]]+\\]"),
      .before = pdf
    )
  
}
