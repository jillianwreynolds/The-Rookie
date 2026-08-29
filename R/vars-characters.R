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
