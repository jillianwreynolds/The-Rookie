# _The Rookie_ Transcript Analysis

`data/html` contains the `HTML` files of the transcript webpages from [the-rookie.fandom.com](https://the-rookie.fandom.com/wiki/The_Rookie_Wiki). A separate folder, `data/html-edited`, contains copies. I used these to check the source code without risk of accidentally modifying the source data. `data` also has folders `Season-*`, which contain PDFs of the Safari Reader view for each episode's transcript. A couple `.txt` files were created for reference during the data cleaning process. Parquet files in `data` were created via code using the [`arrow`](https://arrow.apache.org/docs/r/index.html) package.

`R/` contains scripts for parsing and cleaning the data. Scripts define functions and variables. Some are for data cleaning while others were written to support the data cleaning process. 

I use the [targets](https://docs.ropensci.org/targets/) to create a computation pipeline. The package automatically tracks dependencies, so code is only run when code it depends on is outdated. This pipeline is defined in `_targets.R`.

`scrape_*.R` files contain code for scraping the main cast and characters table and recurring characters list from _The Rookie_'s [Wikipedia page](https://en.wikipedia.org/wiki/The_Rookie). The scraped data is written to `csv` files located in the project root.

The scripts and files for the Shinylive app are located in `app/`; the rendered version that is published through GitHub pages is located in `docs/`.


`helpers/` contains scripts that ease the data cleaning/analysis process or have single-use code (cleaning `HTML` and PDF file names).

`transcripts-exp*.qmd` contain code from exploring the data and testing functions.
