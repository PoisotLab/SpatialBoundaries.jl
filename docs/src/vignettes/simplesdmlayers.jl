# # Integration with SimpleSDMLayers

# The `SpatialBoundaries` package works really well with `SimpleSDMLayers`, so
# that you can (i) apply wombling and boundaries finding to a `SimpleSDMLayer`
# object, and (ii) convert the output of a `Womble` object to a *pair* of
# `SimpleSDMLayer` corresponding to the rate and direction of change.

using SimpleSDMLayers
using SpatialBoundaries
using StatsPlots

# In this example, we will look at precipitation data over the province of
# colonially refered to as Québec, and measure the rate of change, as well as
# the direction of it. These data are extracted from the WorldClim database.

precipitation = SimpleSDMPredictor(WorldClim, BioClim, 12; left=-80.0, right=-56.0, bottom=44.0, top=62.0)

# There is an overload of the `wombling` method for SDM layers, so we can call
# it directly -- this method might result in a bit more memory usage than
# expected, as it requires to transform the `nothing` values into `NaN`s, which
# in turn might require to convert the inner elements of the layer grid.

W = wombling(precipitation)

# By default, this returns a `LatticeWomble`. Let's look at the direction of
# change -- mapping this information is difficult, so we will focus on the 

histogram(vec(W.θ), nbins=36, proj=:polar, yflip = true)

# We can also map the rate of change. This is far easier to do with a proper SDM
# layer, so we will convert the wombling output:

Lr, Ld = SimpleSDMPredictor(W)

# Note that we do not use `convert` here, because this call returns *two* layers
# in a tuple -- this is a slight deviation from what we expect with
# `SimpleSDMLayers`, but it makes the code a little easier to write, and so is
# considered an acceptable trade-off.

plot(Lr, c=:lapaz)