# # Introduction

# Broadly the Wombling algorithm traverses a 'landscape' (for example species
# richness at different degree squares) and describes the the landscape in terms
# of the *Rate of Change (`m`)* (think slope/gradient) and *Direction of Change
# (`θ`)* (direction of slope). For a more in-depth overview you can refer to the
# preprint available at the following
# [10.32942/osf.io/sjxd8](https://t.co/gCyaEXWPVi), otherwise follow along for a
# high-level overview is roughly outlined in the figure below.

# Although the wombling algorithm (as implemented here) is designed to work with
# two-dimensional *i.e.* planar data (as delimited by $x$ and $y$), it is
# beneficial to view this plane as a three-dimensional object (or series of
# curves), as shown in panel A of the figure below. Here the 'amplitude' of the
# curvature of the plane is determined by the value of $z$ and the rate and
# direction of change is calculated by using the first-order partial derivative
# ($\partial$) of the surface (curve) as described by $f(x,y)$ (panel B). Using
# the rate of change it is also possible to identify candidate boundaries
# (dashed line in panel C) in the landscape that indicate 'shifts' from one
# state to another.

# ![image info](assets/fig_concept.png)

# Both rate and direction of change are calculated by interpolating points in a
# given search window which (depending on how the points are arranged in space),
# and can be done in two ways.

# **Lattice Wombling:** For points that are regularly arranged in space the
# search window is 2 × 2 points. Note that the wombled landscape will be will be
# smaller than the original landscape (A) due to the interpolation process
# *i.e.* where we originally had an $n \times r$ grid we now have an ($n$ -
# 1)($r$ - 1) sized grid.

# **Triangulation Wombling:** For points that irregularly arranged in space
# nearest neigbours are found using delaunay triangualtion and interpolation is
# between 3 points.

# In this example, we will see how the `SpatialBoundaries.jl` package works (as
# well as interpreting the rates and direction of change), by taking a random
# mid-point displacement landscape, and measuring its rate and direction of
# change.

using SpatialBoundaries
using NeutralLandscapes
using CairoMakie

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
# smaller than the original grid!). These points are in a grid so the **Lattice
# Wombling** function was used - note that `wombling()` will select the
# appropriate algorithm based on data input.

# Let's have a look at the rate of change:

heatmap(W.m, colormap=:navia, colorrange=(0, maximum(W.m)))

# The rate of change informs us on the potential for there to be a boundary
# (zone of change) within a window. Cells with a high rate of change are
# indicative of large differences (changes) in the landscape 'topology' and are
# suggestive of a boundary as we shift from one 'state' to another.

# The *direction* of change is also given, and is expressed a *wind* direction;
# for instance, an angle of 180° means that the value is smaller in the South,
# and larger in the North:

heatmap(W.θ, colormap=:romaO, colorrange=(0., 360.))

# The direction of change is *not* the direction the boundary would be if you
# were to draw it on the landscape but rather the direction the rate of change
# is 'moving in'. This means it is possible to think of and use the direction of
# change independently of calculating boundaries *per se* and can be used to
# inform how the landscape is behaving/changing in a more 'continuous' way as
# opposed to discrete zones/boundaries. For example if changes in species
# richness are more gradual (rate of change is near constant) but the direction
# of change is consistently South-North (*i.e.* 180°) we can still infer that
# species richness is 'uniformly' increasing in a South-North direction.

# A note on outputs: The new $x$ and $y$ co-ordinates correspond to latitude and
# longitude respectively (which is the opposite of what one might expect).