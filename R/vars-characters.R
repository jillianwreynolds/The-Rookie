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
  names = c("first_name", "last_name")
) |> 
  mutate(across(ends_with("name"), str_to_upper))

women <- c(
  "Abigail", "Abril", "Angela",
  "Bailey", "Blair",
  "Celina",
  "Fiona",
  "Genny", "Grace",
  "Isabel",
  "Jessica",
  "Lila", "Lucy", "Luna",
  "Monica",
  "Nell", "Nyla",
  "Rachel", "Rosalind",
  "Sandra",
  "Talia", "Tamara",
  "Vivian",
  "Zoe"
) |> 
  str_to_upper()

men <- c(
  "Aaron",
  "Ben",
  "Chris",
  "Donovan", "Doug",
  "Elijah", "Emmett",
  "Henry",
  "Jackson", "James", "Jason", "John",
  "Kevin",
  "Liam",
  "Malcolm", "Miles",
  "Nicholas",
  "Oscar",
  "Percy",
  "Quigley",
  "Randy", "Rodge", "Ruben",
  "Sean", "Seth", "Sterling",
  "Tim",
  "Wade", "Wesley"
) |> 
  str_to_upper()

# c(women, men) is one element shorter than characters$first_name because two
# Elijah's
