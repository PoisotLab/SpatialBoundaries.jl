module SBTestSimpleSDMLayers

using SimpleSDMLayers
using SpatialBoundaries
using Test

precipitation = SimpleSDMPredictor(WorldClim, BioClim, 12; left=-80.0, right=-56.0, bottom=44.0, top=62.0)

W = wombling(precipitation)

@test isa(W, LatticeWomble)

end
