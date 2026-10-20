using Genie.Configuration, Logging

Genie.Configuration.config!(
  # GeometryObjects is a package dependency, not an autoloaded app library.
  path_lib                        = joinpath("app", "lib"),
  server_port                     = 8000,
  server_host                     = "0.0.0.0",
  log_level                       = Logging.Error,
  log_to_file                     = false,
  server_handle_static_files      = true, # for best performance set up Nginx or Apache web proxies and set this to false
  path_build                      = "build",
  format_julia_builds             = false,
  format_html_output              = false
)

if Genie.config.server_handle_static_files
  @warn("For performance reasons Genie should not serve static files (.css, .js, .jpg, .png, etc) in production.
         It is recommended to set up Apache or Nginx as a reverse proxy and cache to serve static assets.")
end

ENV["JULIA_REVISE"] = "off"
ENV["GKSwstype"] = "100"
