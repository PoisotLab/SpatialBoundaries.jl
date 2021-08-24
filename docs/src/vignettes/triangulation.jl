# # Triangulation wombling

using SimpleSDMLayers
using SpatialBoundaries
using StatsPlots

# Plot defaults

default(; dpi=500, size=(600, 600), aspectratio=1, c=:davos, frame=:box)

# Get some points at random

n = 120
x = rand(n)
y = rand(n)
z = [sqrt((x[i]-0.4)^2.0)<0.4 ? rand() : rand()+1.1 for i in eachindex(x)]

plot(x, y, marker_z = z)

# Womble

W = wombling(x, y, z)

# Get the rate of change

plot(W.x, W.y, marker_z = W.m)