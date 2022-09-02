module SBTestMean

using SpatialBoundaries
using Statistics
using Test

A = fill(1.0, 10, 12)
W = [wombling(A) for i in 1:10]

@test typeof(mean(W)) isa eltype(W)


end
