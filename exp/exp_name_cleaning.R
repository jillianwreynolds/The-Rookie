source("R/clean_speaker_names2.R")

check_names_vec <- c(
  # move first name, add last name
  "ABIGAIL", "ABRIL",
  "BAILEY", "^BEN$", "BLANCA",
  "DIEGO", "DOMINIQUE", "DONOVAN",
  "ELIJAH", "EMMETT",
  "GENNIFER", "GENNY", "GRACE",
  "ISABEL",
  "JACKSON", "JESSICA", "JOY",
  "KARLA",
  "LILA", "LUNA",
  "NELL",
  "OSCAR",
  "PERCY",
  "RANDY", "RODGE", "ROSALIND", "RUBEN",
  "TAMARA", "TIM",
  "VIVIAN",
  "WESLEY",
  "YVONNE",
  # add first name
  "ANDERSEN", "ARMSTRONG",
  "BISHOP", "BRADFORD",
  "\\bCHEN", "COLINS",
  "DE_LA_CRUZ", "DEL_MONTE", "DERIAN", "DYER",
  "ECKERT",
  "FREEMAN",
  "GLASSER", "GREY",
  "HALL", "HARPER", "HUTCHINSON",
  "JUAREZ",
  "LANG", "LONDON", "LOPEZ",
  "NOLAN",
  "PENN",
  "RIDLEY", "RUSSO", "RYAN",
  "SAWYER", "SMITTY", "STANTON", "STONE",
  "THORSEN",
  "VESTRI",
  "WALSH", "WEST\\b", "WOLFE", "WYLER"
)

check_names_pattern <- check_names_vec |> str_flatten("|")

df_raw |> select(season, episode, speaker, sp1:sp4, transcript) |> 
  filter(str_detect(speaker, check_names_pattern)) |> 
  collect() |> 
  clean_speaker_names2() |> 
  distinct(speaker, .keep_all = TRUE) |> 
  arrange(sp4, sp3) |> 
  print_inf()

df_raw |> select(season, episode, speaker, sp1:sp4, transcript) |> 
  filter(str_detect(speaker, check_names_pattern)) |> 
  collect() |> 
  clean_speaker_names2() |> 
  distinct(speaker, .keep_all = TRUE) |> 
  arrange(sp4, sp3) |> 
  gt() |> 
  tab_style(
    style = cell_fill(color = "#fdd90140"),
    locations = cells_body(
      columns = sp3,
      rows = is.na(sp3)
    )
  )


df_raw |> 
  select(season, episode, speaker, sp1:sp4, transcript) |> 
  filter(str_detect(speaker, check_names_pattern)) |> 
  collect() |> 
  csn2() |> 
  distinct(pick(starts_with("sp")), .keep_all = TRUE) |> 
  arrange(sp4, sp3) |> 
  print_inf()


df_raw |> check_names("malcolm")
df_raw |> check_names("bradford", FALSE)


source("R/check_name_variations.R")
source("R/check_names.R")
source("R/find_which_episodes.R")

# gennifer bradford 5x2

# jason wyler: 4x9, 4x10, 4x11, 6x10, 7x5
