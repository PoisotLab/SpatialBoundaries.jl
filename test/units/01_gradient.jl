module SBTestGradient

using SpatialBoundaries
using NeutralLandscapes
using Test

landscape = rand(PlanarGradient(), 40, 50)
x = collect(LinRange(0.2, 1.8, size(landscape, 1)))
y = collect(LinRange(0.2, 0.8, size(landscape, 2)))

W = wombling(x, y, landscape)
@test isa(W, LatticeWomble)
@test size(W.m) == size(landscape) .- 1
@test length(W.x) == length(x) - 1
@test length(W.y) == length(y) - 1

end
