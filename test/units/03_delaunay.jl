module SBTestDelaunay

using SpatialBoundaries
using NeutralLandscapes
using Test

n = 21
x = rand(n)
y = rand(n)
z = rand(n)

W = wombling(x, y, z)
@test isa(W, TriangulationWomble)
@test length(W.z) == length(W.x)
@test length(W.x) == length(W.y)

end
