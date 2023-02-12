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
using SpeciesDistributionToolkit
using CairoMakie
import Plots # Required for radial histograms

# First we can start by defining the extent of the Southwestern islands of
# Hawaii, which can be used to restrict the extraction of the various landcover
# layers from the EarthEnv database. We do the actual layers querying using
# `SimpleSDMLayers`:

hawaii = (left = -160.2, right = -154.5, bottom = 18.6, top = 22.5)
dataprovider = RasterData(EarthEnv, LandCover)
landcover_classes = SimpleSDMDatasets.layers(dataprovider)
landcover = [SimpleSDMPredictor(dataprovider; layer=class, full=true, hawaii...) for class in landcover_classes]

# We can remove all the areas that contain 100% water from the landcover data as
# our question of interest is restricted to the terrestrial realm. We do this by
# using the "Open Water" layer to mask over each of the landcover layers
# individually:

ow_index = findfirst(isequal("Open Water"), landcover_classes)
not_water = landcover[ow_index] .!== 0x64
lc = [mask(not_water, layer) for layer in landcover]

# As layers one through four of the EarthEnv data are concerned with data on
# woody cover (*i.e.* "Evergreen/Deciduous Needleleaf Trees", "Evergreen
# Broadleaf Trees", "Deciduous Broadleaf Trees", and "Mixed/Other Trees") we
# will work with only these layers. For a quick idea we of what the raw
# landcover data looks like we can sum these four layers and plot the total
# woody cover:

classes_with_trees = findall(contains.(landcover_classes, "Trees"))
tree_lc = convert(Float32, reduce(+, lc[classes_with_trees]))
heatmap(tree_lc; colormap=:linear_kbgyw_5_98_c62_n256)

# Although we have previously summed the four landcover layers for the actual
# wombling part we will apply the wombling function to each layer before we
# calculate the overall mean wombling value. We will do this using `broadcast`,
# this will apply `wombling` in an element-wise fashion to the four different
# woody cover layers. This will give as a vector containing four `LatticeWomble`
# objects (since the input data was in the form of a matrix).

wombled_layers = wombling.(lc[classes_with_trees]);

# As we are interested in overall woody cover for Southwestern islands we can
# take the `wombled_layers` vector and use them with the `mean` function to get
# the overall mean wombling value of the rate and direction of change for woody
# cover. This will 'flatten' the four wombled layers into a single
# `LatticeWomble` object.

wombled_mean = mean(wombled_layers);

# From the `wombled_mean` object we can 'extract' the layers for both the mean
# rate and direction of change. For ease of plotting we will also convert these
# layers to `SimpleSDMPredictor` type objects. It is also possible to call these
# matrices directly from the `wombled_mean` object using `wombled_mean.m` or
# `wombled_mean.θ` for the rate and direction respectively.

rate, direction = SimpleSDMPredictor(wombled_mean)

# Lastly we can identify candidate boundaries using the `boundaries`. Here we
# will use a thresholding value (t) of 0.1 and save these candidate boundary
# cells as `b`. Note that we are now working with a `SimpleSDMResponse` object
# and this is simply for ease of plotting.

b = similar(rate)
b.grid[boundaries(wombled_mean, 0.1; ignorezero = true)] .= 1.0

# We will overlay the identified boundaries (in green) over the rate of change
# (in levels of grey):

heatmap(rate, colormap=[:grey95, :grey5])
heatmap!(b, colormap=[:transparent, :green])
current_figure()

# For this example we will plot the direction of change as radial plots to get
# an idea of the prominent direction of change. Here we will plot *all* the
# direction values from `direction` for which the rate of change is greater than
# zero (so as to avoid denoting directions for a slope that does not exist) as
# well as the `direction` values from only candidate cells using the same
# masking principle as what we did for the rate of change. It is of course also
# possible to forgo the radial plots and plot the direction of change in the
# same manner as the rate of change should one wish.

# Before we plot let us create our two 'masked layers'. For all direction values
# for which there is a corresponding rate of change greater than zero we can use
# `rate` as a masking layer but first replace all zero values with 'nothing'.
# For the candidate boundary cells we can simply mask `direction` with `b` as we
# did for the rate of change.

direction_all = mask(replace(rate, 0 => nothing), direction)

direction_candidate = mask(b, direction)

# Because stephist() requires a vector of radians for plotting we must first
# collect the cells and convert them from degrees to radians. Then we can start
# by plotting the direction of change of *all* cells.

Plots.stephist(
         deg2rad.(values(direction_all));
         proj=:polar,
         lab="",
         c=:teal,
         nbins = 36,
         yshowaxis=false,
         normalize = false)

# Followed by plotting the direction of change only for cells that are
# considered as candidate boundary cells.

Plots.stephist(
        deg2rad.(values(direction_candidate));
        proj=:polar,
        lab="",
        c=:red,
        nbins = 36,
        yshowaxis=false,
        normalize = false)

# End

rm(joinpath(SimpleSDMLayers._layers_assets_path, "EarthEnv"); force=true, recursive=true) #hide