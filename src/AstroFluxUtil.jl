module AstroFluxUtil

# packages that we use throughout
using Base: min, max

using Unitful


# export to make functions/structs available to the user
export Flux
export FluxDensity
export Filter

# include other files in the directory
include("flux.jl")
include("fluxdensity.jl")
include("filter.jl")

end
