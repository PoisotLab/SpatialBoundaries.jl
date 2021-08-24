module SBTestDirection

using SpatialBoundaries
using Test

@test last(SpatialBoundaries._rateofchange(1,1)) == 225.0
@test last(SpatialBoundaries._rateofchange(-1,-1)) == 45.0
@test last(SpatialBoundaries._rateofchange(-1,0)) == 90.0
@test last(SpatialBoundaries._rateofchange(1,0)) == 270.0
@test last(SpatialBoundaries._rateofchange(0,-1)) == 180.0
@test last(SpatialBoundaries._rateofchange(0,1)) == 0.0
@test last(SpatialBoundaries._rateofchange(1,-1)) == 315.0
@test last(SpatialBoundaries._rateofchange(-1,1)) == 135.0

end
