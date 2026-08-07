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
          transcript, "^.+(?=(/Transcript|\\s(T|t)ranscript))"
        ) |> 
          str_remove_all("\"")
        ,
        .before = transcript
      ) |> 
      mutate(
        transcript = str_remove(transcript, "^[\\s\\S]+?\n\n"),
        season = as.numeric(season),
        episode = as.numeric(episode)
      ) |> 
      arrange(season, episode) |> 
      mutate(
        episode_number = row_number(), 
        ep_ID = str_c(season, episode, sep = "x"),
        .before = season
      )
  )
)
