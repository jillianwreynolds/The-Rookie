all_caps_start_words <- c(
  "L\\.A\\.P\\.D\\.",
  "L\\.A\\.",
  "I\\.D\\.",
  "UCLA\\.",
  "ADT\\?",
  "AJ\\.",
  "SWAT\\.",
  "CIA\\.",
  "OK\\.",
  "APM\\.",
  "G-R-O-U-T\\."
)

all_caps_pattern <- str_c(
  "^(",
  all_caps_start_words |> str_flatten(collapse = "|"),
  ")"
)

titles <- tibble(original = c(
  "Dead Bastards MC",      # 1x3,
    "Dead Bastards",       # 2x12 and 4x14
  "50 Shades",             # 1x4
  # 1x7
  "Trading Fire",
  "Trading Fire Five",
  "Catch-22",
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
  "Candyman",
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
  "Rocky",                 # 3x7
  "Real Housewives",       # 4x1
  "Miami Vice",            # 4x9
  "Dirty Harry",           # 5x2
  "Avatar: The Way of Water", # 5x9
  "Bosch",                 # 5x19
  "Chinatown",             # 5x20
  "Top Chef",              # 5x21
  # 8x15
  "300 Days of Hell",
  "The Ring",
  "Scream",
  "Blair Witch Project",
  "THDOH",
  "Survive The Streets"
)) |> 
  mutate(new = original |> str_replace_all("\\s", "_"))

other_proper_nouns <- c(
  "The Badger", # 4x18
  "LA CLEAR",
  "L.A. CLEAR", # 5x16
  "Eliza and Elektra",
  "Joseph & Wells Rare Coins", # 4
  "California State Bar", # 4
  "Polizia Municipale di Roma", # 4x12
  "University of Michigan", # 4x16
  "Make Da Noise", # 4x16
  "Big Foot", # 5x5
  "U. S. Customs" # 5x15
)

stutter_cutoff_letters <- c(
  "I-I-I-",
  "N-",
  "I\\s-",
  "W--",
  "I\\s--",
  "I-I\\.{3}",
  "[IXVTP]\\.{3}",
  "I--",
  "I-I"
)

stutter_cutoff_letters_pattern <- str_c(
  "^(",
  stutter_cutoff_letters |> str_flatten(collapse = "|"),
  ")$"
)
