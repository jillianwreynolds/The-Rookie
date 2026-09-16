httpuv::stopAllServers()

shinylive::export(
  "app", "docs",
  template_params = list(title = "The Rookie Transcript Analysis")
)

httpuv::runStaticServer("docs", port = 9000)
