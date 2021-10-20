# # Wombling with wombats

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

aus_boundingbox = (left=130.0, right=160.0, bottom=-45.0, top=-20.0)
layers_to_keep = [2, 3, 6, 9, 15, 18, 19]

predictors =
    convert.(
        SimpleSDMLayer, SimpleSDMPredictor(WorldClim, BioClim, layers_to_keep; resolution=10.0, aus_boundingbox...)
    );

plot(
    plot.(
        predictors, grid=:none, axes=false, frame=:none, leg=false, c=:imola
    )...,
)

_pixel_score(x) = 2.0(x > 0.5 ? 1.0 - x : x);

# obs should be Boolean

presences = mask(predictors[1], observations, Bool)
plot(convert(Float32, presences); c=cgrad([:lightgrey, :black]), leg=false)


# SDM

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

plot(prediction; c=:bamako, frame=:box)
xaxis!("Longitude")
yaxis!("Latitude")

# ...

# ...

Wr, Wd = SimpleSDMPredictor(wombling(prediction))

# ...

plot(Wr; c=:nuuk)

# ...

heatmap(Wd; c=:brocO, clim=(0.0, 360.0))

# ...
