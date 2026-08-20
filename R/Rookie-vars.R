preview_columns <- c(
  "season",
  "episode",
  "line",
  "type",
  "transcript"
)

captions <- c(
  "OPENING TITLES: THE ROOKIE",
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
