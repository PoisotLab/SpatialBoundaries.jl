module SBTestBoundaries

using SpatialBoundaries
using Test

A = fill(1.0, 10, 12)
W = wombling(A)
@test all(W.m .== zero(eltype(W.m)))
@test all(W.θ .== zero(eltype(W.θ)))
B = boundaries(W)
@test length(B) == prod(size(A).-1)

A = rand(Float64, 101, 101)
W = wombling(A)
B = boundaries(W, 0.2)
@test length(B) == 0.2*prod(size(W.m))

A = rand(Float64, 10, 10)
n = rand(eachindex(A), 10)
A[n] .= NaN
W = wombling(A)
B = boundaries(W)
@test !any(map(isnan, W.m[B]))

end
