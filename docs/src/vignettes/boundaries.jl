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

# We can check out what this patch looks likes:

heatmap(A)

# We can apply a wobling to this landscape, assuming that all cells have the
# same size:

W = wombling(A);

# Let's look at the rate of change:

heatmap(W.m)

# Picking the boundaries is done by passing the wombling output to the
# `boundaries` function, with a specific threshold giving the proportion of
# points that should be retained as part of the boundaries:

B = boundaries(W);

