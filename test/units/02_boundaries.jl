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

A = zeros(Float64, 101, 101)
A[1:51, 1:51] = rand(Float64, 51, 51)
W = wombling(A)
B = boundaries(W, 0.1; ignorezero=true)
@test length(B) == ceil(Int64, 51*51*0.1)

end
