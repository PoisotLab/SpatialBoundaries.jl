# # Wombling with wombats

# We couldn't not have a wombling example without wombats - where's the pun in
# that??

# ![Photo credit to reddit user B_major_7](assets/portal_wombat.png)

#  In this example we will use wombat occurence records from GBIF to construct a
#  bare-bones SDM (using `SimpleSDMLayers.jl`) from which we can look at the
#  habitat boundaries of wombats.

using GBIF
using GeometryBasics
using GLM
using SpatialBoundaries
using SimpleSDMLayers
using StatsBase
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

# Let's grab some climate predictors and make a bare-bones SDM
# For simplicity the BioCLim layers have been 'pre-selected' and 
# a more complete vignette on designing a BIOCLIM model can be 
# found in the
# [SimpleSDMLayers documentation](https://docs.ecojulia.org/SimpleSDMLayers.jl/latest/sdm/bioclim/)

aus_boundingbox = (left=130.0, right=160.0, bottom=-45.0, top=-20.0)
bioclim_layers = [2, 3, 6, 9, 15, 18, 19] # Some pre-determined BioClim layers to pull

predictors =
    convert.(
        SimpleSDMLayer, SimpleSDMPredictor(WorldClim, BioClim, bioclim_layers; aus_boundingbox...)
    );

_pixel_score(x) = 2.0(x > 0.5 ? 1.0 - x : x);

presences = mask(predictors[1], observations, Bool) # Want obs to be boolean

# Actual SDM

function SDM(predictor::T1, observations::T2) where {T1<:SimpleSDMLayer,T2<:SimpleSDMLayer}
    _tmp = mask(observations, predictor)
    qf = ecdf(convert(Vector{Float32}, _tmp[keys(_tmp)])) # We only want the observed values
    return (_pixel_score ∘ qf)
end

function SDM(predictors::Vector{T}, models) where {T<:SimpleSDMLayer}
    @assert length(models) == length(predictors)
    return minimum([broadcast(models[i], predictors[i]) for i in 1:length(predictors)])
end

models = [SDM(predictor, presences) for predictor in predictors];
prediction = SDM(predictors, models)

# Lets have a look at our model

plot(prediction; c=:bamako, frame=:box)
xaxis!("Longitude")
yaxis!("Latitude")


# We can now feed our model predictions into the wombling function
# as you would with any other dataset.

Wr, Wd = SimpleSDMPredictor(wombling(prediction))

# We can now have a look at the rate of change...

plot(Wr; c=:tokyo)

# as well as the direction when it comes to habitat suitability
# for wombats

heatmap(Wd; c=:corkO, clim=(0.0, 360.0))
