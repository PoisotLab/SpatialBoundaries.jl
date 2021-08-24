# # Triangulation wombling

using SpatialBoundaries
using StatsPlots

# Plot defaults

default(; dpi=500, size=(600, 600), aspectratio=1, c=:davos, frame=:box)

# Get some points at random

n = 500
x = rand(n)
y = rand(n)
z = [(x[i]<=0.5)&(y[i]<=0.5) ? rand() : rand().+1.2 for i in eachindex(x)]

scatter(x, y, marker_z = z, lab="")

# Womble

W = wombling(x, y, z)

# Get the rate of change

scatter(x, y, c=:lightgrey, msw=0.0, lab="", m=:square, ms=3)
scatter!(W.x, W.y, marker_z = log1p.(W.m), lab="")

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

scatter(W.x, W.y, marker_z = W.θ, c=:vik, clim=(0, 360))