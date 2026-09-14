# originally scraped on September 14, 2026 between 9 and 10 am

crossover_charachters_text <- "https://en.wikipedia.org/wiki/The_Rookie" |> 
  read_html() |> 
  html_elements("#mwAjg") |> 
  html_text()

crossover_charachters_text |> 
  write_file("data/Wikipedia/crossover_characters_list.txt")
