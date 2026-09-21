# colors ------------------------------------------------------------------

dark_teal   <- "#0a333f"
dark_teal2  <- "#0a333f30"
teal        <- "#2f8b9d"
teal2       <- "#2f8b9d30"
yellow      <- "#facf21"
yellow2     <- "#facf2125"
light_green <- "#b9d4bd"
code_color  <- "#7c13ba"
viridis <- c("#440154FF", "#46337EFF", "#365C8DFF", "#277F8EFF",
             "#1FA187FF", "#4AC16DFF", "#9FDA3AFF", "#FDE725FF")

# bs ----------------------------------------------------------------------

rookie_theme <- bs_theme(
  version = 5,
  bootswatch = "cosmo",
  primary = dark_teal,
  secondary = teal
) |>
  bs_add_variables(
    "headings-color"     = dark_teal,
    "link-color"         = teal,
    "code-color"         = code_color,
    "card-title-color"   = teal
  ) |> 
  bs_add_rules(
    glue(
      "
    .card {
      border-radius: var(--bs-border-radius-lg);
    }
    .accordion {
      --bs-accordion-btn-bg: {{teal2}};
      --bs-accordion-active-bg: {{light_green}};
    }
    .btn-reset {
      background-color: {{teal2}};
      border-color: var(--bs-border-color);
      color: {{dark_teal}};
    }
    .btn-reset:hover {
      background-color: {{yellow}};
      border-color: {{dark_teal}};
      color: {{dark_teal}};
    }
    .vb-yellow {
      background-color: {{yellow2}} !important;
      color: {{dark_teal}}!important;
    }
    ",
      .open = "{{",
      .close = "}}"
    )
  )


# ggplot ------------------------------------------------------------------

gg_theme <- theme_light() +
  theme(
    axis.title = element_text(size = 15),
    axis.text = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 13)
  )
