module SpatialBoundaries

# Dependencies
using VoronoiDelaunay
using LinearAlgebra
using SimpleSDMLayers
using Statistics
using StatsBase
using Requires

include(joinpath("types", "Womble.jl"))
export Womble, TriangulationWomble, LatticeWomble

include(joinpath("lib", "rateofchange.jl"))

include(joinpath("lib", "wombling.jl"))
export wombling

include(joinpath("lib", "boundaries.jl"))
export boundaries

include(joinpath("lib", "overallmean.jl"))
export mean

include(joinpath("extensions", "SimpleSDMLayers.jl"))

