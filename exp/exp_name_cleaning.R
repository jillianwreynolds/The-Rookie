source("R/clean_speaker_names2.R")

check_names_vec <- c(
  # move first name, add last name
  "ABIGAIL", "ABRIL",
  "BAILEY", "^BEN$", "BLANCA",
  "DIEGO", "DOMINIQUE", "DONOVAN",
  "ELIJAH", "EMMETT",
  "GRACE",
  "ISABEL",
  "JACKSON", "JESSICA", "JOY",
  "KARLA",
  "LILA", "LUNA",
  "NELL",
  "OSCAR",
  "PERCY",
  "RODGE", "ROSALIND", "RUBEN",
  "TAMARA", "TIM",
  "WESLEY",
  "YVONNE",
  # add first name
  "ANDERSEN", "ARMSTRONG",
  "BISHOP", "BRADFORD",
  "\\bCHEN", "COLINS",
  "DE_LA_CRUZ", "DEL_MONTE", "DERIAN", "DYER",
  "FREEMAN",
  "GREY",
  "HALL", "HARPER", "HUTCHINSON",
  "JUAREZ",
  "LANG", "LOPEZ",
  "NOLAN",
  "PENN",
  "RUSSO", "RYAN",
  "SAWYER", "SMITTY", "STANTON", "STONE",
  "THORSEN",
  "VESTRI",
  "WEST\\b", "WOLFE"
)

check_names_pattern <- check_names_vec |> str_flatten("|")

df_raw |> select(season, episode, speaker, sp1:sp4, transcript) |> 
  filter(str_detect(speaker, check_names_pattern)) |> 
  collect() |> 
  clean_speaker_names2() |> 
  distinct(speaker, .keep_all = TRUE) |> 
  arrange(sp4, sp3) |> 
  print_inf()


df_raw |> check_names("sanford wes")
df_raw |> check_names("sanford", FALSE)


source("R/check_name_variations.R")
source("R/check_names.R")
source("R/find_which_episodes.R")


# Mark Murray 3x13
# James Murray is not Murray in 4x13
