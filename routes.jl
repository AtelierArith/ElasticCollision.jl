using Genie.Router
using Plots

using ParticlesController

route("/") do
    ParticlesController.rendergif()
end