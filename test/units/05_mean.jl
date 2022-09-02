module SBTestMean

using SpatialBoundaries
using Test

A = fill(1.0, 10, 12)
W = [wombling(A) for i in 1:10]

@test mean(W) isa eltype(W)


end
