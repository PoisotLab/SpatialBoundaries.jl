module SBTestBoundaries

using SpatialBoundaries
using Test

A = fill(1.0, 10, 12)
W = wombling(A)
@test all(W.m .== zero(eltype(W.m)))
@test all(W.θ .== zero(eltype(W.θ)))
B = boundaries(W)
@test length(B) == prod(size(A).-1)

A[4, 8] = 5.0
A[5, 8] = 5.0
W = wombling(A)
B = boundaries(W; threshold=0.03)
@test length(B) == 5

end
