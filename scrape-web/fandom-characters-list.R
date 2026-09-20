# Originally scraped on September 20, 2026 between 1 and 3 pm
  
"https://the-rookie.fandom.com/api.php?action=query&list=categorymembers&cmtitle=Category:Characters&cmlimit=500&format=json" |> 
  httr::GET() |> 
  httr::content() |> 
  _$query$categorymembers |> 
  keep(\(x) x$ns == 0) |> 
  map_chr("title") |> 
  write_lines("data/fandom-characters-list.txt")
