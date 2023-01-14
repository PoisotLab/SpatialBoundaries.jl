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

wombled_mean = mean(wombled_layers)

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

for t in 0.1
    b.grid[boundaries(wombled_mean, t; ignorezero=true)] .= t
end

# In addition to being used to help find candidate boundary cells we can also
# use this object (`b`) as masking layer when visualising wombling outputs. In
# this case we can view the `rate` layer  in a similar fashion to the original
# landcover layer but by masking it with `b` we only plot the candidate
# boundaries *i.e.* the cells with the top 10% of highest rate of change values.

plot(
    # first plot a grey 'basemap'
    plot(rate; c=:black, frame=:box),
    # plot masked rate of change values
    mask(b, rate); 
    c=:grey75, frame=:box, colorbar=false)

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
# collect the cells and convert them from degrees to radians.

stephist(
        stephist(
                deg2rad.(collect(direction_all));
                proj=:polar,
                lab="All cells",
                c=:teal,
                fill=(0, 0.2, :teal),
                nbins=100,
                #guide="",
                yshowaxis=false,
                normalize = true
               ),
            deg2rad.(collect(direction_candidate));
                proj=:polar,
                lab="Boundary cells",
                c=:red,
                fill=(0, 0.2, :red),
                nbins=100,
                #guide="",
                yshowaxis=false,
                normalize = true
        )
