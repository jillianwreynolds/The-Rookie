# originally scraped on September 14, 2026 between 9 and 10 am

notable_guests_text <- "https://en.wikipedia.org/wiki/The_Rookie" |> 
  read_html() |> 
  html_elements("#mwAW0") |> 
  html_text()

notable_guests_text |> 
  write_file("data/Wikipedia/notable_guests_list.txt")
