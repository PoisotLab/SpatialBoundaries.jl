# # Finding boundaries

# The output of a `wombling` operation can be used to pick boundaries, *i.e.*
# areas where the values on the grid transition sharply. We will illustrate this
# with a simple example of a three-patch landscape.

using SpatialBoundaries
using StatsPlots
default(; dpi=500, size=(600, 600), aspectratio=1, c=:batlow, frame=:box)

# Let's create a landscape with two values:

A = rand(Float64, 200, 150);
A[1:80, 1:85] .+= 5.0;
A[110:end, 130:end] .+= 3.0;

# We can check out what this landscape looks likes:

heatmap(A)

# We can apply wombling to this landscape, assuming that all cells have the same
# size:

W = wombling(A);

# Let's look at the rate of change:

heatmap(W.m; c=:nuuk)

# Picking the boundaries is done by passing the wombling output to the
# `boundaries` function, with a specific threshold giving the proportion of
# points that should be retained as part of the boundaries. Checking what the
# effect of this threshold is would be a good idea:

thresholds = LinRange(0.0, 0.2, 200)
patches = [length(boundaries(W; threshold=t)) for t in thresholds]

plot(thresholds, log1p.(patches), aspectratio=:none)
xaxis!("Threshold", (0., 0.2))
yaxis!("log(boundary patches + 1)", (0., 9.))

# Let's eyeball this as a 0.01, and see how the patches are distributed.

# Another way we can look at the boundaries is to see *when* a patch is
# considered to be a boundary. To do so we will create an empty matrix, and fill
# each position with the lowest threshold at which it is considered to be a
# boundary:

b = similar(W.m)

for t in reverse(LinRange(0.0, 1.0, 200))
    b[boundaries(W; threshold=t)] .= t
end

heatmap(b, c=:tofino, clim=(0,1))

# This also suggests that we will get well delineated patches for low values of
# the threshold.

B = boundaries(W; threshold=0.01);

# In the following figure, cells identified as candidate boundaries are marked
# in white:

heatmap(A)
scatter!([(reverse(x.I)) for x in B], leg=false, msw=0, c=:white)

# We can see that the boundaries of the patches have been well identified!