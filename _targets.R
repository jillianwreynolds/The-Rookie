# Load packages required to define the pipeline:
library(targets)
library(arrow)
library(gt)

tar_option_set(
  packages = c("tidyverse")
)

tar_source()

list(
  tar_target(
    transcript_list,
    list.files("data/", pattern = "\\.pdf$", recursive = TRUE)
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
    transcripts_parquet,
    {
      transcripts |> write_parquet("data/transcripts_parquet.parquet")
      "data/transcripts_parquet.parquet"
    },
    format = "file"
  ),
  tar_target(
    transcripts_lines,
    {
      transcripts |> 
        pre_split_clean() |> 
        transcripts_to_lines() |>
        write_parquet("data/transcripts_lines.parquet")
      "data/transcripts_lines.parquet"
    },
    format = "file"
  ),
  tar_target(
    transcripts_clean,
    {
      open_dataset(transcripts_lines) |>
        collect() |>
        clean_transcripts() |>
        split_italics_dialogue() |> 
        left_join(
          transcripts |> select(-c(pdf, html)),
          by = join_by(season, episode)
        ) |> 
        write_parquet("data/transcripts_clean.parquet")
      "data/transcripts_clean.parquet"
    },
    format = "file"
  )
)
