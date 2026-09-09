clean_proper_nouns <- function(tbl, include_other = FALSE) {
  
  titles <- tibble(original = c(
    "50 Shades",             # 1x4
    # 1x7
    "Trading Fire",
    "Trading Fire Five",
    "Trading Fire Two",
    "Death Wish",            # 1x9
    "Architectural Digest",  # 1x11
    "Midnight Apocalypse",   # 1x17
    "Rio Bravo",             # 2x1
    # 2x2
    "Split Second Leadership: Leading Men In The Line Of Duty",
    "Split Second Leadership",
    "Downton Abbey",         # 2x3
    # 2x4
    "Aeronautics Through the Ages",
    "Willy Wonka",           # and 5x1 and 6x6
    "Lady and the Tramp",    # 2x8
    # 2x9
    "Hot Suspect",           # and 2x12
    "The Maltese Falcon",
    "Cop Rock",
    "Teen Rebel",            # 2x11
    "The Great British Baking Show", # 2x14
    "The Godfather",         # 2x15
    "I Never Loved a Man",   # 2x16,
    "Los Angeles <i>Herald</i>", # 2x16
    # 2x17
    "Action Heist",
    "The Bachelor",          # and 4x1 and 5x19
    "The Cardinal",
    "General Hospital",      # 3x1
    "Paul's Place",          # 3x7
    "Real Housewives",       # 4x1
    "Miami Vice",            # 4x9
    "Dirty Harry",           # 5x2
    "Avatar: The Way of Water", # 5x9
    "Top Chef",              # 5x21
    # 8x15
    "300 Days of Hell",
    "The Ring",
    "Blair Witch Project",
    "Survive The Streets"
  ))
  
  other <- tibble(original = c(
    "Dead Bastards MC",           # 1x3,
      "Dead Bastards",              # 2x12 and 4x14
    "LA CLEAR",                   # 2x14 and 4x3
      "L.A. CLEAR",                 # 5x16
    "The Badger",                 # 3x11 and 4x18
    "Eliza and Elektra",          # 4x3
    "Joseph & Wells Rare Coins",  # 4x6
    "California State Bar",       # 4x9
    "Polizia Municipale di Roma", # 4x12
    # 4x16
    "University of Michigan",
    "Make Da Noise",
    "Big Foot",                   # 5x5
    "U. S. Customs"               # 5x15
  ))
  
  if (include_other) {
    text <- bind_rows(titles, other)
  } else {
    text <- titles
  }
  
  text <- text |> mutate(new = original |> str_replace_all("\\s", "_"))
  
  tbl |> 
    mutate(transcript = map_chr(transcript, \(x) {
      reduce2(text$original, text$new, \(acc, x, y) {
        str_replace_all(acc, coll(x), y)
      }, .init = x)
    })
    )
  
}
