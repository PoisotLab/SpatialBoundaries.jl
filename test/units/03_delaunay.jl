module SBTestDelaunay

using SpatialBoundaries
using Test

n = 21
x = rand(n)
y = rand(n)
z = rand(n)

W = wombling(x, y, z)
@test isa(W, TriangulationWomble)
@test length(W.m) == length(W.x)
@test length(W.x) == length(W.y)

end
