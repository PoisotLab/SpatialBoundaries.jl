# # Introduction

# ## Understanding Outputs

# Broadly the Wombling algorthim traverses a given 'landscape' (for example species 
# richness) and describes the the landscape in terms of the _Rate of Change (𝑀)_ 
# (think slope/gradient) and _Direction of Change (θ)_ (direction of slope). 
# **TODO FIGURE with a hypothetical landscpe but also schematic of the process**.

# Something brief on the interpolation process?

# In this example, we will see how the `SpatialBoundaries.jl` package works, by
# taking a random mid-point displacement landscape, and measuring its rate and
# direction of change.

using SpatialBoundaries
using NeutralLandscapes
using StatsPlots

# We will set a few options for the default plots:

default(; dpi=500, size=(600, 600), aspectratio=1, c=:davos, frame=:box)

# The landscape generation is done using the `NeutralLandscapes` package, and we
# will pick a 500x500 grid:

landscape_size = (500, 500)
landscape = rand(MidpointDisplacement(0.75), landscape_size...)

# By default, lattice wombling will assume that the cells have the same size,
# which is 1/n (where n is the number of cells on each side), but  you can
# specify your own `x` and `y` arguments.

# We can take a quick peek at the landscape:

heatmap(landscape)

# Getting the lattice wombling is done with

W = wombling(landscape);

# The resulting `LatticeWomble` object has fields for the rate of change (`m`),
# the direction of change in degrees (`θ`), and the values of the centers of the
# cells at `x` and `y` (note that the grid of rates of change is one cell
# smaller than the original grid!).

# Let's have a look at the rate of change:

heatmap(W.m, c=:bilbao, clim=(0, maximum(W.m)))

# The rate of change informs us on the potential for there to be a boundary
# (zone of change) within a specific cell. Cells with a high rate of change are
# indicative of large differences (changes) in the landscape topology and are
# suggestive of a boundary as we shift from one 'state' to another e.g.
# transitioning from a protected to an urban area.

# The *direction* of change is also given, and is expressed a *wind* direction;
# for instance, an angle of 180° means that the value is smaller in the South,
# and larger in the North:

heatmap(W.θ, c=:brocO, clim=(0., 360.))

# The direction of change is _not_ the direction the boundary would be if you
# were to draw it on the landscape but rather the direction the rate of change
# is 'moving in'. This means it is possible to think of and use the direction of
# change independently of caluclating boundaries _per se_ and can be used to
# inform how the landscape is behaving/changing in a more 'continuous' way as
# opposed to discrete zones/boundaries. For example if changes in species
# richness are more gradual (rate of change is near constant) but the the
# direction of change is consistently South-North (i.e. 180°) we can still infer
# that species richness is 'uniformly' increasing in a South-North direction.