"""
    Unexported function to deal with the coordinates required by VoronoiDelaunay
"""
function _nrm(v, m, M, n, N)
    vn = (v .- m) ./ (M - m)
    return (vn .* (N - n)) .+ n
end

"""
    wombling(x::Vector{T}, y::Vector{T}, z::Vector{T}) where {T<:Number}

Wrapper function that implements the triangulation wombling algorithm for points
that are irregularly arranged in space.
"""
function wombling(x::Vector{T}, y::Vector{T}, z::Vector{T}) where {T<:Number}
    length(x) >= 4 || throw(DimensionMismatch("x must have a minimum length of 4"))
    length(x) == length(y) ||
        throw(DimensionMismatch("x and y must have the same dimension"))
    length(x) == length(z) ||
        throw(DimensionMismatch("x and z must have the same dimension"))

    # Get the range of values for the points
    min_value, max_value = extrema(vcat(x, y))

    # Project the points in the correct range of values
    nx = _nrm(x, min_value, max_value, min_coord, max_coord)
    ny = _nrm(y, min_value, max_value, min_coord, max_coord)
    px = Point2D[Point(nx[i], ny[i]) for i in eachindex(x)]
    
    # Build the Delaunay triangulation
    tess = DelaunayTessellation()
    push!(tess, px)
    triangles = unique(tess)

    _M = zeros(T, length(triangles))
    _θ = similar(_M)
    _X = similar(_M)
    _Y = similar(_M)

    # Get the rate of change for the points
    for (i, triangle) in enumerate(tess)
        simplices_coordinates = [
            findfirst(isequal(triangle._a), px),
            findfirst(isequal(triangle._b), px),
            findfirst(isequal(triangle._c), px),
        ]
        c = hcat(x, y)[simplices_coordinates, :]
        _x = c[:, 1]
        _y = c[:, 2]
        _z = z[simplices_coordinates]
        _M[i], _θ[i] = SpatialBoundaries._rateofchange(_x, _y, _z)
        _X[i] = sum(c[:, 1]) / 3.0
        _Y[i] = sum(c[:, 2]) / 3.0
    end

    # Rate of change and direction
    return TriangulationWomble(_M, _θ, _X, _Y)
end

"""
    wombling(x::Vector{T}, y::Vector{T}, z::Matrix{T}) where {T<:Number}

Wrapper function that implements the lattice wombling algorithm for points that
are regularly arranged in space. Note that the matrix is presented in a way that
is flipped, *i.e.* the `x` coordinates corresponds to the rows, and the `y`
coordinates correspond to the columns. If you want to think of `x` and `y` as
geographic coordinates, `y` are the longitudes, and `x` are the latitudes. Using
the bindings for `SimpleSDMLayers`, this conversion will be performed
automatically.
"""
function wombling(x::Vector{T}, y::Vector{T}, z::Matrix{T}) where {T<:Number}
    issorted(x) || throw(ArgumentError("The values of x must be sorted and increasing"))
    issorted(y) || throw(ArgumentError("The values of y must be sorted and increasing"))
    length(x) == size(z, 1) || throw(
        DimensionMismatch("The length of x must be equal to the first dimension of z")
    )
    length(y) == size(z, 2) || throw(
        DimensionMismatch("The length of y must be equal to the second dimension of z")
    )

    _M = zeros(T, size(z) .- 1)
    _θ = similar(_M)

    for j in 1:size(_M, 2), i in 1:size(_M, 1) # womble along a 2x2 window
        tmp = z[i:(i + 1), j:(j + 1)]
        _M[i, j], _θ[i, j] = SpatialBoundaries._rateofchange(
            x[i:(i + 1)], y[j:(j + 1)], tmp
        )
    end

    # Rate of change and direction
    return LatticeWomble(
        _M,
        _θ,
        x[1:(end - 1)] .+ 0.5 .* vec(x[2:end] .- x[1:(end - 1)]),
        y[1:(end - 1)] .+ 0.5 .* vec(y[2:end] .- y[1:(end - 1)]),
    )
end

"""
    wombling(m::Matrix{T}) where {T<:Number}

Shortcut to womble a matrix (using lattice wombling) when no x and y positions
are given - the cell size in each dimension is expected to be 1.
"""
function wombling(m::Matrix{T}) where {T<:Number}
    return wombling(convert.(T, 1:size(m, 1)), convert.(T, 1:size(m, 2)), m)
end
