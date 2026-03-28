# # Finding boundaries

# The output of a `wombling` operation can be used to pick boundaries, *i.e.*
# areas where the values within the landscape transition sharply indicating
# different 'patches'. We will illustrate this with a simple example of a
# three-patch landscape.

using SpatialBoundaries
using CairoMakie

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

heatmap(W.m; colormap = :Greys)

# Picking the boundaries is done by passing the wombling output to the
# `boundaries` function, with a specific threshold giving the proportion of
# points that should be retained as part of the boundaries. Checking what the
# effect of this threshold is would be a good idea:

thresholds = LinRange(0.0, 0.2, 200)
patches = [length(boundaries(W, t)) for t in thresholds]

f, ax, plt = lines(thresholds, log1p.(patches), color=:black, linewidth=2)
tightlimits!(ax)
ax.xlabel = "Threshold"
ax.ylabel = "log(boundary patches + 1)"
f

# Let's eyeball this as 0.01, and see how the patches are distributed.

# Another way we can look at the boundaries is to see *when* a patch is
# considered to be a boundary. To do so we will create an empty matrix, and fill
# each position with the lowest threshold at which it is considered to be a
# boundary:

b = similar(W.m)

for t in reverse(LinRange(0.0, 1.0, 300))
    b[boundaries(W, t)] .= t
end

heatmap(b, colormap=:tofino, colorrange=(0,1))

# This also suggests that we will get well delineated patches for low values of
# the threshold.

B = boundaries(W, 0.01);

# In the following figure, cells identified as candidate boundaries are marked
# in white:

f, ax, hm = heatmap(A)
scatter!(ax, [b.I for b in B], color=:white)
f

# We can see that the boundaries of the patches have been well identified!
