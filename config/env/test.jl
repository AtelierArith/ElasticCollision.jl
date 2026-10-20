using Genie.Configuration, Logging

Genie.Configuration.config!(
  # GeometryObjects is a package dependency, not an autoloaded app library.
  path_lib                        = joinpath("app", "lib"),
  server_port                     = 8000,
  server_host                     = "127.0.0.1",
  log_level                       = Logging.Debug,
  log_to_file                     = true,
  server_handle_static_files      = true
)

ENV["JULIA_REVISE"] = "off"
ENV["GKSwstype"] = "100"