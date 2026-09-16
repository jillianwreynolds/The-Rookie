# _The Rookie_ Transcript Analysis

`data/` contains zip files for `HTML` and PDF versions of each episode's transcript. Both zip files have a folder for each season. `htmls.zip` contains `HTML` files of the transcript webpages from [the-rookie.fandom.com](https://the-rookie.fandom.com/wiki/The_Rookie_Wiki). `pdfs.zip` contain PDFs of the Safari Reader view for each episode's transcript. A couple of `.txt` files were created for reference during the data cleaning process. Parquet files in `data` were created via code using the [`arrow`](https://arrow.apache.org/docs/r/index.html) package.

`R/` contains scripts for parsing and cleaning the data. Scripts define functions and variables. Some are for data cleaning while others were written to support the data cleaning process. 

I use the [targets](https://docs.ropensci.org/targets/) package to create a computation pipeline. The package automatically tracks dependencies, so code is only run when code that it depends on is outdated. This pipeline is defined in `_targets.R`.

`scrape_Wikipedia/` contains scripts for scraping the cast and characters table and lists from _The Rookie_'s [Wikipedia page](https://en.wikipedia.org/wiki/The_Rookie). The scraped data is written to `parquet` and `txt` files located in `data/Wikipedia/`.

Episode rating data comes from IMDb data downloaded on July 31, 2026 from https://datasets.imdbws.com. It was downloaded and cleaned for another project; I wrote the data to a parquet file for this project.

The scripts and files for the Shinylive app are located in `app/`; the rendered version that is published through GitHub pages is located in `docs/`.

`helpers/` contains scripts that ease the data cleaning/analysis process or have single-use code (cleaning `HTML` and PDF file names, for example).

`exp/` contains files written while exploring the data and testing functions.
