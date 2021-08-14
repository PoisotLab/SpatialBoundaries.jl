module SBTestBoundaries

using SpatialBoundaries
using Test

A = fill(1.0, 10, 12)
W = wombling(A)

@test all(W.m .== zero(eltype(W.m)))
@test all(W.θ .== zero(eltype(W.θ)))

B = boundaries(W)

@test length(B) == prod(size(A).-1)

end
