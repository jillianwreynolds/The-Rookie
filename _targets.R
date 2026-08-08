# Load packages required to define the pipeline:
library(targets)

tar_option_set(
  packages = c("tidyverse")
)

tar_source()

list(
  tar_target(
    transcript_list,
    list.files("data/The-Rookie/", recursive = TRUE)
  ),
  tar_target(
    transcripts_raw,
    transcript_list |> map(\(x) {
      
      path <- paste0("data/The-Rookie/", x)
      name <- x |> str_extract("(?<=\\d{1}/).+(?=\\.pdf)")
      
      text <- path |> 
        pdf_text() |> 
        str_flatten()
      
      tribble(
        ~ transcript,
        text
      )
      
    }) |> 
      bind_rows(),
    packages = "pdftools"
  ),
  tar_target(
    transcripts_html,
    parse_episode_html() |> 
      mutate(
        html_path = basename(html_path) |> str_remove("\\.html"),
        transcript = str_remove(transcript, "^[\\s\\S]+?\"[^\"]+\"\n{1,2}")
      ) |> 
      rename(title = html_path),
    packages = c("rvest", "xml2")
  ),
  tar_target(
    transcripts,
    transcripts_raw |> 
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
      left_join(transcripts_html, by = join_by(title)) |> 
      rename(pdf = transcript.x, html = transcript.y) |> 
      mutate(
        transcript = str_remove_all(html, "<i>[\\s\\S]+?</i>") |> 
          str_remove_all("\\([^)]+\\)") |>
          str_remove_all("\\[[^]]+\\]"),
        .before = pdf
      )
  ),
  tar_target(
    transcripts_clean,
    {
      clean_transcripts(transcripts) |> 
        write_parquet("data/The-Rookie/transcripts_clean.parquet")
      "data/The-Rookie/transcripts_clean.parquet"
    },
    format = "file",
    packages = "arrow"
  )
)
