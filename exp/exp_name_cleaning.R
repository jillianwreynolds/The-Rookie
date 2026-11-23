# source("R/clean_speaker_name_parts.R")

check_names_vec <- c(
  # move first name, add last name
  "ABIGAIL", "ABRIL", "AUSTIN",
  "BAILEY", "^BEN$", "BLANCA",
  "DIEGO", "DOMINIQUE", "DONOVAN",
  "ELIJAH", "EMMETT",
  "GENNIFER", "GENNY", "GRACE$",
  "ISABEL",
  "JACKSON", "JESSICA", "JOY",
  "KARLA",
  "LILA", "LUNA",
  "NELL",
  "OSCAR",
  "PERCY",
  "RANDY", "RODGE", "ROSALIND", "RUBEN$",
  "SIMON",
  "TAMARA", "TIM", "TYLER",
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
  "HALL$", "HARPER", "HUTCHINSON",
  "JUAREZ",
  "LANG", "LONDON", "LOPEZ$",
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
  arrange(sp4, sp3, speaker, season, episode) |> 
  print_inf()


df_raw |> select(season, episode, speaker, sp1:sp4, transcript) |> 
  filter(str_detect(speaker, check_names_pattern)) |> 
  collect() |> 
  distinct(pick(starts_with("sp")), .keep_all = TRUE) |> 
  arrange(sp4, sp3, speaker, season, episode) |> 
  print_inf()

df_raw |> check_names("henry")
df_raw |> check_names("henry", show_speaker_part_cols = TRUE)
df_raw |> check_names("elena", peek = FALSE)
df_raw |> check_names("mrs\\.", peek = FALSE, show_speaker_part_cols = TRUE)


source("R/check_name_variations.R")
source("R/check_names.R")
source("R/find_which_episodes.R")

notable_guest_chars

crossover_chars_long
