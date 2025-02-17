module SBTestSimpleSDMLayers

using SpatialBoundaries
using SpeciesDistributionToolkit
using Test

precipitation = SDMLayer(
    RasterData(CHELSA1, BioClim);
    layer = 12,
    left = -66.0,
    right = -62.0,
    bottom = 45.0,
    top = 46.5,
)

W = wombling(precipitation)

@test isa(W.rate, SDMLayer)
@test isa(W.direction, SDMLayer)

# Test with a gradient
X = zeros(Float64, 200, 200)
for i in 1:size(X, 1)
    X[i, :] .= i
end
grad = SDMLayer(X)

Z = wombling(grad)

@test all(unique(values(Z.rate)) .== 1.0)
@test all(unique(values(Z.direction)) .== 180.0)

end
