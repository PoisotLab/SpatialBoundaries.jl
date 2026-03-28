module SBTestGradient

using SpatialBoundaries
using NeutralLandscapes
using Test

angles = rand(100) .* 360

for angle in angles
    landscape = rand(PlanarGradient(angle), 20, 20)
    x = collect(LinRange(0.2, 1.8, size(landscape, 1)))
    y = collect(LinRange(0.2, 1.8, size(landscape, 2)))

    W = wombling(x, y, landscape)

    for θ in W.θ
        @test deg2rad(abs(θ  - angle)) ≈ π atol = 0.01
    end
end

end
