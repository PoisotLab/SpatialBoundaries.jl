module SpatialBoundaries

# Dependencies

using CSV: CSV
using DataFrames
using Delaunay
using LinearAlgebra
using NeutralLandscapes
using Plots
using SimpleSDMLayers
using SpatialEcology
using Statistics
using StatsPlots

# Load and export types and function
include(joinpath("lib", "rateofchange.jl")) # internal functions

include(joinpath("lib", "wombling.jl")) # will prob export this function

include(joinpath("lib", "boundaries.jl")) #will prob export this function
# export Whatever

end
