transcripts |> pull(html) |> 
  # nth(134) |> 
  nth(105) |> 
  str_replace_all("\n", "\U1f534") |> 
  # peek_match("(?<=\U1f534)\\s(?=\U1f534)") |>
  str_replace_all("(?<=\U1f534)\\s(?=\U1f534)", "\U1f7e2") |> 
  peek_match("(?<=\U1f534)\U1f7e2(?=\U1f534)")

transcripts |> pull(html) |> nth(136) |> 
  str_replace_all("\n", "\U1f534") |> 
  peek_match("(?<=\U1f534)\\s(?=\U1f534)")

"tacker.🔴NOLAN🔴I got" |> str_split("\U1f534")

"view?🔴🔴LOPEZ🔴Zombies" |> str_split("\U1f534")

"apparently.🔴🔴WESLEY🔴Oh.🔴🔴🔴🔴🔴 🔴NOLAN🔴Thank" |> str_split("\U1f534")


"Clear!\n\n\n \nGREY\nPackage is secure.\n\n \nCHEN\nTest test" |> 
  str_remove_all("(?<=\\n)\\s??(?=\\n)") |> 
  str_replace_all("\n{4,}", "\U1f534") |> 
  str_replace_all("\n{3}", "\U1f7e3") |> 
  cat()


"SWAT OFFICER\nGo, go, go. -- Clear!\n\n\n \nGREY\nPackage is secure.\n\nGARZA\nYour" |> 
  str_remove_all("(?<=\\n)\\s??(?=\\n)") |> 
  str_replace_all("\n{4,}", "\U1f534") |> 
  str_replace_all("\n{3}", "\U1f7e3") |> 
  cat()

test_split_transcripts <- function(tbl) {
  
  tbl |> 
    mutate(
      html = html |> 
        str_remove_all("(?<=\\n)\\s(?=\\n)") |> 
        str_replace_all("\n{3,}", "U1f534")
    )
  
}
