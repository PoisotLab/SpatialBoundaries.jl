# # Wombling with wombats

using GBIF
using SpatialBoundaries
using SimpleSDMLayers
using Statistics

# We can extract wombat occurence records using `GBIF.jl`

observations = occurrences(taxon("Vombatus ursinus"; rank=:SPECIES), "country" => "AU")

while length(observations) <= min(2_500, size(observations))
    occurences!(observations)
end

# Let's grab some climate predictors

aus_boundingbox = (left=110.0, right=160.0, bottom=-46.0, top=-8.0)
layers = SimpleSMDPredictors(WorldClim, BioClim, 1:10; aus_boundingbox...)

# https://docs.ecojulia.org/SimpleSDMLayers.jl/stable/sdm/gbif/

observation_density = mask(temperature, observations, Float32)
observation_kernels = slidingwindow(observation_density, mean, 100.0)

# ...

plot(observation_kernels)

# ...

Wr, Wd = SimpleSDMPredictor(wombling(observations_kernels))

# ...

heatmap(Wr; c=:nuuk)

# ...

heatmap(Wd; c=:brocO, clim=(0.0, 360.0))

# ...
