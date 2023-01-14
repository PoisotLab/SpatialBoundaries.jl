# # Integration with SimpleSDMLayers

# Below is an example using the various functions within `SpatialBoundaries` to
# estimate boundaries for (*i.e.* patches of) wooded areas on the Southwestern
# islands of the Hawaiian Islands using landcover data from the EarthEnv project
# [@Tuanmu2014Glo1km] as well as integrating some functionality from
# `SimpleSDMLayers` [@Dansereau2021SimJl] for easier work with the spatial
# nature of the input data. The `SpatialBoundaries` package works really well
# with `SimpleSDMLayers`, so that you can (i) apply wombling and boundaries
# finding to a `SimpleSDMLayer` object, and (ii) convert the output of a
# `Womble` object to a *pair* of `SimpleSDMLayer` corresponding to the rate and
# direction of change.

# Because there are four different layers in the EarthEnv database that
# represent different types of woody cover we will use the overall mean wombling
# value. As the data are arranged in a matrix *i.e.* a lattice this example will
# focus on lattice wombling, however for triangulation wombling the
# implementation of functions and workflow would look similar with the exception
# that the input data would be structured differently (as three vectors of $x$,
# $y$, $z$) and the output data would be typed as `TriangulationWomble` objects.

using SpatialBoundaries
using SimpleSDMLayers
using Plots

# Note that the warning about dependencies is a side-effect of loading some
# functionalities for `SimpleSDMLayers` as part of `SpatialBoundaries`, and can
# safely be ignored.

# First we can start by defining the extent of the Southwestern islands of
# Hawaii, which can be used to restrict the extraction of the various landcover
# layers from the EarthEnv database. We do the actual database querying using
# `SimpleSDMLayers`.

hawaii = (left=-160.2, right=-154.5, bottom=18.6, top=22.5)

landcover = SimpleSDMPredictor(EarthEnv, LandCover, 1:12; hawaii...)

# We can remove all the areas that contain 100% water from the landcover data as
# our question of interest is restricted to the terrestrial realm. We do this by
# using the "Open Water" layer to mask over each of the landcover layers
# individually.

ow_index = findfirst(isequal("Open Water"), layernames(EarthEnv, LandCover))

not_water = broadcast(!isequal(100), landcover[ow_index])

lc = [mask(not_water, layer) for layer in landcover]

# As layers one through four of the EarthEnv data are concerned with data on
# woody cover (*i.e.* "Evergreen/Deciduous Needleleaf Trees", "Evergreen
# Broadleaf Trees", "Deciduous Broadleaf Trees", and "Mixed/Other Trees") we
# will work with only these layers. For a quick idea we of what the raw
# landcover data looks like we can sum these four layers and plot the total
# woody cover for the Southwestern islands.

tree_lc = convert(Float32, sum(lc[1:4]))

plot(tree_lc; c=:bamako, frame=:box)

# Although we have previously summed the four landcover layers for the actual
# wombling part we will apply the wombling function to each layer before we
# calculate the overall mean wombling value. We will do this using `broadcast`,
# this will apply `wombling` in an element-wise fashion to the four different
# woody cover layers. This will give as a vector containing four `LatticeWomble`
# objects (since the input data was in the form of a matrix).


wombled_layers = broadcast(wombling, (lc[1:4]))

# As we are interested in overall woody cover for Southwestern islands we can
# take the `wombled_layers` vector and use them with the `mean` function to get
# the overall mean wombling value of the rate and direction of change for woody
# cover. This will 'flatten' the four wombled layers into a single
# `LatticeWomble` object.

