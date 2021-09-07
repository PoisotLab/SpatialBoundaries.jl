module SBTestDirection

using SpatialBoundaries
using Test

@test last(SpatialBoundaries._rategradient(1.0,1.0)) == 225.0
@test last(SpatialBoundaries._rategradient(-1.0,-1.0)) == 45.0
@test last(SpatialBoundaries._rategradient(-1.0,0.0)) == 90.0
@test last(SpatialBoundaries._rategradient(1.0,0.0)) == 270.0
@test last(SpatialBoundaries._rategradient(0.0,-1.0)) == 180.0
@test last(SpatialBoundaries._rategradient(0.0,1.0)) == 0.0
@test last(SpatialBoundaries._rategradient(1.0,-1.0)) == 315.0
@test last(SpatialBoundaries._rategradient(-1.0,1.0)) == 135.0

end
