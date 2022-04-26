module SpatialBoundaries

# Dependencies
using VoronoiDelaunay
using LinearAlgebra
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

function __init__()
    @require SimpleSDMLayers = "2c645270-77db-11e9-22c3-0f302a89c64c" include(
        joinpath("extensions", "SimpleSDMLayers.jl")
    )
end

end
