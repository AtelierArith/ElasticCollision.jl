using Pkg

Pkg.activate(@__DIR__)
geometry = joinpath(@__DIR__, "lib")
isfile(joinpath(geometry, "Project.toml")) || error("Missing GeometryObjects submodule. Run `git submodule update --init --recursive` first.")
Pkg.develop(path=geometry)
Pkg.instantiate()
