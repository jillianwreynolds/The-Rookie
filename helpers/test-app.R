httpuv::stopAllServers()

shinylive::export("app", "docs")

httpuv::runStaticServer("docs", port = 3838)
