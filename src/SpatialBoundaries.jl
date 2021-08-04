module SpatialBoundaries

# Dependencies
using Delaunay
using LinearAlgebra
using Statistics
using StatsBase

include(joinpath("lib", "rateofchange.jl"))

include(joinpath("lib", "wombling.jl"))

include(joinpath("lib", "boundaries.jl"))

end
