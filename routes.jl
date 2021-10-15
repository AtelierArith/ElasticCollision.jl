using Genie.Router
using Plots

using ParticlesController

route("/") do
    maxT = min(1000, parse(Int, params(:maxT, "100")))
    num_particles = min(80, parse(Int, params(:num_particles, "30")))
    ParticlesController.rendergif(;maxT, num_particles)
end
