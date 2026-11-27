url <- "https://en.wikipedia.org/wiki/List_of_The_Rookie_episodes#Episodes"

html <- url |> 
  read_html() |> 
  html_elements(".module-episode-list-row")

str(html[1])


url |> read_html() |> html_elements('//*[@id="mwcw"]/tbody/tr[2]/td[4]')

# xpath
# //*[@id="mwcw"]/tbody/tr[2]/td[4]


ep1x1 <- html[1] |> xml_children()

ep1x1[5]

html[1] |> xml_child(5)

url |> 
  read_html() |> 
  html_elements('//*[@id="mwcw"]/tbody/tr[2]/td[4]')

url |> 
  read_html() |> 
  html_elements(".module-episode-list-row") |> 
  html_text()

url |> 
  read_html() |> 
  html_elements(".module-episode-list-row") |> 
  html_text2()

episode_tables <- url |> 
  read_html() |> 
  html_elements(".wikiepisodetable") |> 
  html_table()

episode_tables[1] |> list_flatten()

episode_tables[1] |> class()

episode_tables[[1]] |> class()

episode_tables[[1]] |> View()

setNames(episode_tables, str_c("episodes_s", 1:8))

episode_tables <- setNames(episode_tables, str_c("episodes_season", 1:8))

list2env(episode_tables, envir = globalenv())

episode_tables |> 
  list_rbind() |> 
  rename(
    number_in_series = `No.overall`,
    number_in_season = `No. inseason`,
    director = `Directed by`,
    writer = `Written by`,
    prod_code = `Prod.code`,
    US_viewers_millions = `U.S. viewers(millions)`
  ) |> 
  rename_with(\(x) {
    x |> str_remove("\\s\\[.+\\]") |> str_to_lower() |> str_replace_all(" ", "_")
  }) |> 
  filter(str_detect(number_in_series, "[0-9]+"))

clean_episode_tables <- function(data) {
  
  data |> 
    rename(
      number_in_series = `No.overall`,
      number_in_season = `No. inseason`,
      director = `Directed by`,
      writer = `Written by`,
      US_viewers_millions = `U.S. viewers(millions)`
    ) |> 
    rename_with(\(x) {
      x |> 
        str_remove(" \\[.+$") |> 
        str_replace(coll("U.S."), "US") |> 
        str_replace_all("\\s|\\.", "_") |> 
        str_to_lower() |> 
        str_replace("^us", "US")
    })
  
}

episode_tables |> clean_episode_tables() |> colnames()

iwalk(episode_tables, \(x, nm) {
  
  tbl <- x |> 
    clean_episode_tables()
  
  assign(nm, tbl, envir = globalenv())
  
})

map(episode_tables, \(x, nm) {
  
  x |> clean_episode_tables()
  
}) |> 
  list_rbind()

map(episode_tables, \(x) {colnames(x)})


url |> 
  read_html() |> 
  html_elements(".wikiepisodetable .module-episode-list-row") |> 
  html_text2() |> 
  tibble() |> 
  separate_wider_delim(everything(), delim = "\t", names = c(
    "number_in_series", "number_in_season", "title", 
    "director", "writer",
    "original_release_date", "prod_code",
    "US_viewers_millions"
  )) |> 
  mutate(
    title = title |> str_remove("^\"") |> str_remove("\"$"),
    original_release_date = original_release_date |> 
      str_extract("(?<=\\().+(?=\\))") |> 
      ymd(),
    season = prod_code |> str_extract("^.")
  ) |> 
  relocate(season, .after = number_in_series)
