module SBTestSimpleSDMLayers

using SpatialBoundaries
using SpeciesDistributionToolkit
using Test

precipitation = SDMLayer(
    RasterData(CHELSA1, BioClim);
    layer = 12,
    left = -80.0,
    right = -56.0,
    bottom = 44.0,
    top = 62.0,
)

W = wombling(precipitation)

@test isa(W.rate, SDMLayer)
@test isa(W.direction, SDMLayer)

end
