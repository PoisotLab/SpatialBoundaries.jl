# # Triangulation wombling

using SpatialBoundaries
using CairoMakie
using StatsBase

# Get some points at random

n = 500
x = 2rand(n)
y = rand(n)
z = [(x[i] <= 0.5) & (y[i] <= 0.5) ? rand() : rand() .+ 1.2 for i in eachindex(x)]

scatter(x, y; color = z)

# Womble

W = wombling(x, y, z)

# Get the rate of change

scatter(x, y; color = :lightgrey)
scatter!(W.x, W.y; color = log1p.(W.m))
current_figure()

# Angle histogram

f = Figure()
ax = PolarAxis(f[1, 1])
h = fit(Histogram, deg2rad.(values(W.θ)); nbins = 100)
stairs!(ax, h.edges[1], h.weights[[axes(h.weights, 1)..., 1]]; color = :teal, linewidth = 2)
current_figure()

# Show the rotation with a color

scatter(W.x, W.y; color = W.θ, colormap = :vikO, colorrange = (0, 360))