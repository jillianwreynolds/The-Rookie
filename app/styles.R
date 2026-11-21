css <- glue(
  "
  .empty-card {
  --bs-border-color-translucent: white
  }
  .ReactTable {
      font-family: var(--bs-body-font-family) !important;
    }
    .bslib-navs-card-title {
      background: {{teal}};
      color: white;
    }
    #ratings_stats_card .nav-link {
    --bs-nav-link-color: {{dark_teal}};
    --bs-nav-link-hover-color: {{teal}};
    background-color: {{light_green}};
    }
    #ratings_stats_card .nav-link.active {
    background-color: {{dark_teal}};
    --bs-nav-pills-link-active-color: white;
    }
    .value-first .value-box-area {
      display: flex;
      flex-direction: column;
    }
    .value-first .value-box-value {
      order: -1;
      font-size: 3rem;
    }
    .value-first .value-box-title {
      order: 0;
    }
    .median_season_ratings .value-box-grid {
      background-color: {{teal2}};
    }
    #n_episodes_vb .value-box-grid {
      background-color: {{yellow2}};
    }
  ",
  .open  = "{{",
  .close = "}}"
)

rookie_slider_css <- glue(
  "
  .irs-grid-pol.small { height: 0px; }
  .slider-animate-button {
    color: {{dark_teal}};
    font-size: 13pt; 
    top: 10px;
  }
  .irs--shiny .irs-handle {
    background: {{yellow}};
    border-color: {{yellow}};
    width: 20px;
    height: 20px;
    top: 19px
  }
  .irs--shiny .irs-handle:hover {
    background: {{light_green}};
    border-color: {{light_green}}
  }
  
  .irs--shiny .irs-handle:active {
    background: {{light_green}};
    border-color: {{light_green}}
  }
  .irs--shiny .irs-bar {
    background: {{teal}};
    border: {{teal}};
  }
  .irs-grid-text {
    font-size: 16px;
    color: {{dark_teal}};
  }
  .irs--shiny .irs-from,
  .irs--shiny .irs-to,
  .irs--shiny .irs-single {
    font-size: 14px;
    background-color: {{teal}};
    top: -3px
  }
  .irs--shiny .irs-min, .irs--shiny .irs-max {
    background: white;
    color: white;
    font-size: 1pt
  }
  ",
  .open = "{{",
  .close = "}}"
)
