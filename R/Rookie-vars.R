preview_columns <- c(
  "season",
  "episode",
  "line",
  "type",
  "transcript"
)

captions <- c(
  "OPENING TITLESTHE ROOKIE",
  "NINE MONTHS LATER",
  "ONE MONTH LATER",
  "\"DAY 2\"",
  "\"DAY 4\"",
  "97 MINUTES EARLIER",
  "6 WEEKS LATER",
  "TO BE CONTINUED...",
  "12 HOURS EARLIER"
)

all_caps_start_words <- c(
  "OK",
  "NO",
  "LAPD", "LAP-",
  "UCLA",
  "FBI",
  "ADT",
  "AJ",
  "MDMA",
  "VARDA",
  "IBAN"
)

all_caps_pattern <- str_c(
  "^([A-Z]+|[A-Z][a-z]{1,2}[A-Z]+)(",
  all_caps_start_words |> str_flatten(collapse = "|"),
  ")"
)

other_type_patterns <- c(
  "^CLIPS\\sFROM.+\"FREE\\sFALL"
)

italicized_titles <- c(
  "50 Shades",
  "Trading Fire",
  "Trading Fire Five",
  "Trading Fire Two",
  "Catch-22",
  "Death Wish",
  "Architectural Digest",
  "Midnight Apocalypse",
  "Rio Bravo",
  "Split Second Leadership: Leading Men In The Line Of Duty.",
  "Split Second Leadership: Leading Men In The Line Of Duty",
  "Split Second Leadership",
  "Downton Abbey",
  "Aeronautics Through the Ages",
  "Lady and the Tramp",
  "Hot Suspect",
  "The Maltese Falcon",
  "Cop Rock",
  "Candyman",
  "Teen Rebel",
  "The Great British Baking Show",
  "The Godfather",
  "Los Angeles Herald",
  "Herald",
  "Action Heist",
  "The Bachelor",
  "The Cardinal",
  "General Hospital",
  "Paul's Place",
  "Rocky",
  "Dirty Harry.",
  "Dirty Harry",
  "Bosch",
  "Top Chef",
  "Chinatown",
  "300 Days of Hell",
  "The Ring",
  "Scream",
  "Blair Witch Project",
  "THDOH",
  "Dead Bastards MC", #2x4
  "Willy Wonka"
)

dispatch_names <- c(
  "911\\sDISPATCHER",
  "9-1-1\\sDISPATCH",
  "9-1-1\\sOPERATOR",
  "9-1-1",
  "911\\sOPERATOR"
) 

dispatch_pattern <- str_c(
  "^(",
  dispatch_names |> str_flatten(collapse = "|"),
  ")"
)

main_chars <- tribble(
  ~name,             ~gender,
  "John Nolan",       "M",
  "Lucy Chen",        "F",
  "Tim Bradford",     "M",
  "Angela Lopez",     "F",
  "Wade Grey",        "M",
  "Nyla Harper",      "F"
) |> separate_wider_delim(
  name,
  delim = " ",
  names = c("first_name", "last_name"),
  too_many = "merge"
) |> 
  mutate(across(ends_with("name"), str_to_upper))
  
characters <- tribble(
  ~name,             ~gender,
  "John Nolan",       "M",
  "Lucy Chen",        "F",
  "Jackson West",     "M",
  "Tim Bradford",     "M",
  "Angela Lopez",     "F",
  "Talia Bishop",     "F",
  "Nyla Harper",      "F",
  "Wade Grey",        "M",
  "Aaron Thorsen",    "M",
  "Celina Juarez",    "F",
  "Miles Penn",       "M",
  "Seth Ridley",      "M",
  "Quigley Smitty",   "M",
  "Wesley Evers",     "M",
  "James Murray",     "M",
  "Bailey Nune",      "F",
  "Tamara Colins",    "F",
  "Luna Grey",        "F",
  "Rodge Bronson",    "M",
  "Sean Del Monte",   "M",
  "Genny Bradford",   "F",
  "Chris Sanford",    "M",
  "Randy Spitz",      "M"
  # "Zoe Andersen",     "F",
  # "Nell Forester",    "F",
  # "Isabel Bradford",  "F",
  # "Henry Nolan",      "M",
  # "Abigail Tierney",  "F",
  # "Ben McRee",        "M",
  # "Percy West",       "M",
  # "Jessica Russo",    "F",
  # "Grace Sawyer",     "F",
  # "Oscar Hutchinson", "M",
  # "Nick Armstrong",   "M",
  # "Rosalind Dyer",    "M",
  # "Monica Stevens",   "F",
  # "Elijah Stone",     "M",
  # "Liam Glasser",     "M",
  # "Malcolm Walsh",    "M",
  # "Vivian Eckert",    "F"
) |> 
  separate_wider_delim(
    name,
    delim = " ",
    names = c("first_name", "last_name"),
    too_many = "merge"
  ) |> 
  mutate(caps = str_to_upper(last_name))
