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

end
