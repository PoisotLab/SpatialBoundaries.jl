# # Integration with SimpleSDMLayers

# The `SpatialBoundaries` package works really well with `SimpleSDMLayers`, so
# that you can (i) apply wombling and boundaries finding to a `SimpleSDMLayer`
# object, and (ii) convert the output of a `Womble` object to a *pair* of
# `SimpleSDMLayer` corresponding to the rate and direction of change.

using SimpleSDMLayers
using SpatialBoundaries
using StatsPlots

# Note that the warning about dependencies is a side-effect of loading some
# functionalities for `SimpleSDMLayers` as part of `SpatialBoundaries`, and can
# safely be ignored.

# In this example, we will look at temperature data over North America, and
# measure the rate of change, as well as the direction of it. These data are
# extracted from the WorldClim database.

temperature = SimpleSDMPredictor(
    WorldClim, BioClim, 1; left=-130.0, right=-65.0, bottom=5.0, top=65.0
)

# We can have a look at this layer, after setting a few defaults:

default(; dpi=500, size=(600, 600), aspectratio=1, c=:davos, frame=:box)
plot(temperature)

# There is an overload of the `wombling` method for SDM layers, so we can call
# it directly -- this method might result in a bit more memory usage than
# expected, as it requires to transform the `nothing` values into `NaN`s, which
# in turn might require to convert the inner elements of the layer grid.

W = wombling(temperature)

# By default, this returns a `LatticeWomble`. Let's look at the direction of
# change -- mapping this information is difficult, so we will focus on the 

stephist(
    deg2rad.(sort(vec(W.θ)));
    proj=:polar,
    lab="",
    c=:teal,
    fill=(0, 0.2, :teal),
    nbins=100,
)

# The values for the direction of change are concentrated around 180° - note
# that the direction of change is reported as a wind direction, meaning that
# values tend to increase on a south-north axis.

# We can also map the rate of change. This is far easier to do with a proper SDM
# layer, so we will convert the wombling output:

Lr, Ld = SimpleSDMPredictor(W)

# Note that we do not use `convert` here, because this call returns *two* layers
# in a tuple -- this is a slight deviation from what we expect with
# `SimpleSDMLayers`, but it makes the code a little easier to write, and so is
# considered an acceptable trade-off.

plot(Lr)

# With the `Ld` layer storing the direction of change, we *can* do a map - the
# main issue with mapping directions is colors, which need to have the same
# begin and endpoint, while remaining accessible to people with color vision
# defficiencies. [Cyclic color schemes](https://www.fabiocrameri.ch/colourmaps/)
# work for this purpose:

plot(Ld, c=:brocO, clim=(0, 360))