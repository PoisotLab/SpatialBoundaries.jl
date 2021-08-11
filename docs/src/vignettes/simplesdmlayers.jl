# # Integration with SimpleSDMLayers

using SimpleSDMLayers
using SpatialBoundaries
using StatsPlots


precipitation = SimpleSDMPredictor(WorldClim, BioClim, 12; left=-80.0, right=-56.0, bottom=44.0, top=62.0)

W = wombling(precipitation)

heatmap(W.m)

heatmap(W.θ)