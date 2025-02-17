# # Triangulation wombling

using SpatialBoundaries
using CairoMakie

# Get some points at random

n = 500
x = rand(n)
y = rand(n)
z = [(x[i]<=0.5)&(y[i]<=0.5) ? rand() : rand().+1.2 for i in eachindex(x)]

scatter(x, y, color = z, lab="")

# Womble

W = wombling(x, y, z)

# Get the rate of change

scatter(x, y, color=:lightgrey, msw=0.0, lab="", m=:square, ms=3)
scatter!(W.x, W.y, marker_z = log1p.(W.m), lab="")
current_figure()

# Angle histogram

stephist(
    deg2rad.(sort(vec(W.θ)));
    proj=:polar,
    lab="",
    c=:teal,
    fill=(0, 0.2, :teal),
    nbins=100,
)

# Show the rotation with a color

scatter(W.x, W.y, marker_z = W.θ, c=:vikO, clim=(0, 360))