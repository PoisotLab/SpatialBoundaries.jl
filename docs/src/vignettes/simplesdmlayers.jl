# # Integration with SimpleSDMLayers

# The `SpatialBoundaries` package works really well with `SimpleSDMLayers`, so
# that you can (i) apply wombling and boundaries finding to a `SimpleSDMLayer`
# object, and (ii) convert the output of a `Womble` object to a *pair* of
# `SimpleSDMLayer` corresponding to the rate and direction of change.

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

# First we can start by defining the extent of Britain and Ireland, which can be
# used to restrict the extraction of the various landcover layers from the
# EarthEnv database. We do the actual database querying using `SimpleSDMLayers`.

british_isles = (left=-11.0, right=3.0, bottom=49.0, top=62.0)

landcover = SimpleSDMPredictor(EarthEnv, LandCover, 1:12; british_isles...)

# We can remove all the areas that contain 100% water from the landcover data as
# our question of interest is restricted to the terrestrial realm. We do this by
# using the "Open Water" layer to mask over the other landcover layers.

ow_index = findfirst(isequal("Open Water"), layernames(EarthEnv, LandCover))

not_water = broadcast(!isequal(100), landcover[ow_index])

lc = [mask(not_water, layer) for layer in landcover]

# As layers one through four of the EarthEnv data are concerned with data on
# woody cover (*i.e.* "Evergreen/Deciduous Needleleaf Trees", "Evergreen
# Broadleaf Trees", "Deciduous Broadleaf Trees", and "Mixed/Other Trees") we
# will work with only these layers. For a quick idea we of what the raw data
# looks like we can sum these four layers and plot the total woody cover for the
# British Isles.

tree_lc = convert(Float32, sum(lc[1:4]))

plot(tree_lc; 
    c=:bamako, frame=:box)

# Although we previously summed the four landcover layers for the actual
# wombling part we will apply the wombling function to each layer before we
# calculate the overall mean wombling value. We will do this using the
# `broadcast` that will apply `wombling` in an element-wise fashion to the four
# different woody cover layers. This will give as a vector containing four
# `LatticeWomble` objects (as the initial input was a matrix).

wombled_layers = broadcast(wombling, (lc[1:4]))

# As we are interested in overall woody cover for Britain and Ireland we can
# take the `wombled_layers` vector and use them with the `mean` function to get
# the overall mean wombling value of the rate and direction of change for woody
# cover. This will 'flatten' the four wombled layers into a single
# `LatticeWomble` layer.

wombled_mean = mean(wombled_layers)

# From the mean wombled layer we can 'extract' the layers for both the mean rate
# and direction of change. For ease of plotting we will also convert them to
# `SimpleSDMPredictor` type objects. It is also possible to call these matrices
# directly from the `wombled_mean` object using `wombled_mean.m` or
# `wombled_mean.θ` for the rate and direction respectively.

rate, direction = SimpleSDMPredictor(wombled_mean)

# Lastly we can identify candidate boundaries using the boundaries function. By
# using a range of thresholding values we can observe the effect of varying the
# threshold. Here we will use a thresholding value (t) of 0.1 (*i.e.*) and save
# these candidate boundaries as `b`.

b = similar(rate)

for t in 0.1
    b.grid[boundaries(wombled_mean, t; ignorezero=true)] .= t
end

# In addition to being used to help find candidate boundary cells we can also
# use this object (`b`) as masking layer when visualising wombling outputs. In
# this case we can view the `rate` layer  in a similar fashion to the original
# landcover layer but by masking it with `b` we only plot the candidate
# boundaries.

plot(
    # first plot a grey 'basemap'
    plot(rate; c=:grey75, frame=:box),
    # plot masked rate of change values
    mask(b, rate); 
    c=:imola, frame=:box)

# For this example we will plot the direction of change as radial plots to get
# an idea of the prominent direction of change. Here we will plot *all* the
# direction values from `wombled_mean.θ` (it is easier for the inputs used by
# stephist() to work with the raw values as opposed to a `SimpleSDMPredictor`
# object) as well as the `direction` values from only candidate cells using the
# same masking principle. Because stephist() requires a vector as sorted vector
# we must first collect and arrange the direction values and then convert to
# radians for plotting. It is of course also possible to forgo the radial plots
# and plot the direction of change in the same manner as the direction of change
# should one wish.

stephist(
        stephist(
                deg2rad.(sort(vec(wombled_mean.θ)));
                proj=:polar,
                lab="All cells",
                c=:teal,
                fill=(0, 0.2, :teal),
                nbins=100,
                #guide="",
                yshowaxis=false,
                normalize = true
               ),
            deg2rad.(sort(vec(collect(mask(b, direction)))));
                proj=:polar,
                lab="Boundary cells",
                c=:red,
                fill=(0, 0.2, :red),
                nbins=100,
                #guide="",
                yshowaxis=false,
                normalize = true
        )

# The values for the direction of change are concentrated around 180° - note
# that the direction of change is reported as a wind direction, meaning that
# values tend to increase on a south-north axis.