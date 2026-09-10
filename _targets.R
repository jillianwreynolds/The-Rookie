library(targets)
library(tarchetypes)
library(arrow)
library(gt)

tar_option_set(
  packages = c("tidyverse"),
  error = "trim"
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
      transcripts |> 
        select(ep_number, season, episode, title) |> 
        write_parquet("data/transcripts_parquet.parquet")
      "data/transcripts_parquet.parquet"
    },
    format = "file"
  ),
  tar_target(
    df_raw,
    {
      transcripts |> 
        run_cleaning_pipe() |>
        write_parquet("data/df_raw.parquet")
      "data/df_raw.parquet"
    },
    format = "file"
  ),
  tar_target(
    df_clean,
    {
      transcripts |> 
        run_cleaning_pipe(clean = TRUE) |>
        write_parquet("data/df_clean.parquet")
      "data/df_clean.parquet"
    },
    format = "file"
  )#,
  # tar_target(
  #   test_clean,
  #   {
  #     open_dataset(transcripts_lines) |>
  #       collect() |>
  #       clean_transcripts() |>
  #       split_italics_dialogue() |> 
  #       split_dialogue_italicized_descriptions() |> 
  #       left_join(
  #         transcripts |> select(-c(pdf, html)),
  #         by = join_by(season, episode)
  #       ) |> 
  #       write_parquet("data/test_clean.parquet")
  #     "data/test_clean.parquet"
  #   },
  #   format = "file"
  # )
)
