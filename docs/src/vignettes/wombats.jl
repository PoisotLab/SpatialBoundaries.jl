# # Wombling with wombats

using GBIF
using SpatialBoundaries
using SimpleSDMLayers
using Statistics
using StatsPlots

# We can extract wombat occurence records using `GBIF.jl`

observations = occurrences(
    taxon("Vombatus ursinus"; rank=:SPECIES),
    "hasCoordinate" => true,
    "decimalLatitude" => "-45,-20",
    "decimalLongitude" => "130,160",
    "limit" => 300,
)

while length(observations) <= min(10_000, size(observations))
    occurrences!(observations)
end

# Let's grab some climate predictors

aus_boundingbox = (left=130.0, right=160.0, bottom=-45.0, top=-20.0)
layers = SimpleSDMPredictor(WorldClim, BioClim, 1:19; aus_boundingbox...)

# https://docs.ecojulia.org/SimpleSDMLayers.jl/stable/sdm/gbif/

observation_density = mask(layers[1], observations, Float32)
plot(observation_density)

# ...

observation_kernels = slidingwindow(observation_density, mean, 150.0)
plot(observation_kernels)

# ...

# ...

Wr, Wd = SimpleSDMPredictor(wombling(observation_kernels))

# ...

plot(Wr; c=:nuuk)

# ...

heatmap(Wd; c=:brocO, clim=(0.0, 360.0))

# ...
