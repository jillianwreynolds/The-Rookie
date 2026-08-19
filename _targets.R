# Load packages required to define the pipeline:
library(targets)

tar_option_set(
  packages = c("tidyverse")
)

tar_source()

list(
  tar_target(
    transcript_list,
    list.files("data/The-Rookie/", pattern = "\\.pdf$", recursive = TRUE)
  ),
  tar_target(
    transcripts_raw, read_pdfs(transcript_list), packages = "pdftools"
  ),
  tar_target(
    transcripts_html, parse_episode_html(), packages = c("rvest", "xml2")
  ),
  tar_target(
    transcripts, join_pdf_html(transcripts_raw, transcripts_html)
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
