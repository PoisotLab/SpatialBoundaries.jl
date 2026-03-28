module SBTestGradient

using SpatialBoundaries
using NeutralLandscapes
using Test

angles = rand(100) .* 360

for replicate in Base.OneTo(10)
    θ1 = rand(angles)
    θ2 = rand(angles)
    L1 = rand(PlanarGradient(θ1), 20, 20)
    L2 = rand(PlanarGradient(θ2), size(L1)...)
    x = collect(LinRange(0.2, 1.8, size(L1, 1)))
    y = collect(LinRange(0.2, 1.8, size(L1, 2)))

    W = mean([wombling(x, y, L) for L in [L1, L2]])

    α1 = deg2rad(θ1)
    α2 = deg2rad(θ2)
    target = atan(sin(α1)+sin(α2), cos(α1)+cos(α2))
    observed = deg2rad(rand(W.θ))

    diff = (target-observed) - 2π
    if abs(diff) > 0.01
        @test diff ≈ -2π atol = 0.001
    else
        @test diff ≈ 0.0 atol = 0.001
    end
end

end
