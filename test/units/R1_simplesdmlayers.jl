module SBTestSimpleSDMLayers

using SpatialBoundaries
using SpeciesDistributionToolkit
using Test

precipitation = SimpleSDMPredictor(
    RasterData(WorldClim, BioClim),
    layer=12;
    left = -80.0,
    right = -56.0,
    bottom = 44.0,
    top = 62.0,
)

W = wombling(precipitation)

@test isa(W, LatticeWomble)

Lt, Ld = SimpleSDMPredictor(W)
@test isa(Lt, SimpleSDMPredictor)

Rt, Rd = SimpleSDMResponse(W)
@test isa(Rt, SimpleSDMResponse)

@test !any(map(isnan, Rt.grid))
@test !any(map(isnan, Rd.grid))

end
