using Genie.Router
using Plots

using ParticlesController

route("/") do
    maxT = min(100, parse(Int, params(:maxT, "50")))
    num_particles = min(30, parse(Int, params(:num_particles, "10")))
    ParticlesController.rendergif(;maxT, num_particles)
end
