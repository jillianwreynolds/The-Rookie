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
  "Abigail", "Abril", "Angela", "Anna", "Antoinette", "Ashley",
  "Bailey", "Blair",
  "Celina", "Charlotte", "Claire",
  "Daylin", "Denise",
  "Elena", "Erin", "Evelyn",
  "Fiona",
  "Genny", "Grace",
  "Isabel",
  "Jessica", "Joy",
  "Katerina", "Katie", "Katy", "Kylie",
  "Laura", "Lila", "Lucy", "Luna",
  "Megan", "Monica",
  "Nell", "Nyla",
  "Rachel", "Rosalind",
  "Sandra", "Sarah", "Simone",
  "Talia", "Tamara",
  "Valerie", "Vanessa", "Vic", "Vivian",
  "Yvonne",
  "Zoe"
) |> 
  str_to_upper()

men <- c(
  "Aaron", "Alejandro",
  "Ben", "Brad", "Brendan",
  "Caleb", "Carson", "Carter", "Chaz", "Chris","Cooper", "Corey",
  "Dash", "Donovan", "Doug",
  "Eli", "Elijah", "Elroy", "Emmett", "Eric",
  "Franco",
  "Harrison", "Henry",
  "Jackson", "Jacob", "Jake", "James", "Jason", "Jeremy", "Jerry", "John",
  "Kevin",
  "Lance", "Larry", "Liam", "Lionel", "Luke",
  "Malcolm", "Malvado", "Mario", "Mark", "Matthew", "Max", "Michael", "Miles",
  "Nicholas", "Noah",
  "Oliver", "Oscar",
  "Patrick", "Percy", "Pete", "Pierre",
  "Quigley",
  "Rainn", "Randy", "Ray", "Robert", "Rodge", "Ruben", "Ryan",
  "Sam", "Sanford", "Sean", "Seth", "Sterling",
  "Tim", "Tom", "Trent",
  "Wade", "Wesley", "will.i.am",
  "Zac"
) |> 
  str_to_upper()

# last_name_only
# Dr. Morgan ~ F
# Sharp ~ M

# two: Caleb, Elijah, Eric

# Check for multiples: Jordan, Chris, Sam, Billie, Kelly, Charlie
