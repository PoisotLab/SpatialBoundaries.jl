module SpatialBoundaries

# Dependencies
import Delaunay
using LinearAlgebra
using Statistics
using StatsBase

include(joinpath("types", "Womble.jl"))
export Womble, TriangulationWomble, LatticeWomble

include(joinpath("lib", "rateofchange.jl"))

include(joinpath("lib", "wombling.jl"))
export wombling

include(joinpath("lib", "boundaries.jl"))
export boundaries

end
