using Revise
using SimpleSDMLayers
using NeutralLandscapes
using SpatialBoundaries
using Plots
using Statistics

layers = SimpleSDMPredictor(
    CHELSA, BioClim, 1:19; left=-76.0, right=-65.0, bottom=47.0, top=58.0
)

z = [(l-mean(l))/(std(l)) for l in layers]

# Standardized layers
w = [wombling(layer) for layer in z]

# Overall mean lattice wombling value
m = omlwv(w)

# Plot!
heatmap(m.m, aspectratio=1)

# Histogram of direction
stephist(
    deg2rad.(sort(vec(m.θ)));
    proj=:polar,
    lab="",
    c=:teal,
    fill=(0, 0.2, :teal),
    nbins=100
)