tar_edit()

tar_outdated()

tar_visnetwork()
tar_visnetwork(targets_only = TRUE)
tar_visnetwork(physics = TRUE)
tar_visnetwork(targets_only = TRUE, physics = TRUE)

tar_make()

tar_meta(fields = warnings, complete_only = TRUE)
tar_meta(fields = error, complete_only = TRUE)

tar_meta(fields = name)
tar_meta(fields = name) |> print_inf()
tar_meta(fields = name) |> filter(str_detect(name, ""))

tar_manifest()
