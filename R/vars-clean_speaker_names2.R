move_first_add_last_tbl <- tibble(name = c(
  "ABIGAIL", "ABRIL",
  "BAILEY", "BEN", "BLANCA",
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
  "YVONNE"
))

add_first_tbl <- tibble(name = c(
  "ANDERSEN", "ARMSTRONG",
  "BISHOP", "BRADFORD",
  "CHEN", "COLINS",
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
  "WALSH", "WEST", "WOLFE", "WYLER"
))

additional_chars <- tribble(
  ~name,       ~replacement,
  "BLANCA",    "JUAREZ",
  "DIEGO",     "DE_LA_CRUZ",
  "DOMINIQUE", "GREY",
  "GENNIFER",  "BRADFORD",
  "JOY",       "BRADFORD",
  "KARLA",     "JUAREZ",
  "YVONNE",    "THORSEN"
)
