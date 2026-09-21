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
