"""
    wombling(x::Vector{T}, y::Vector{T}, z::Vector{T}) where {T<:Number}

Wrapper function that implements the triangulation wombling algorithm for points
that are irregularly arranged in space.
"""
function wombling(x::Vector{T}, y::Vector{T}, z::Vector{T}) where {T<:Number}
    length(x) >= 3 || throw(DimensionMismatch("x must have a minimum length of 3"))
    length(x) == length(y) ||
        throw(DimensionMismatch("x and y must have the same dimension"))
    length(x) == length(z) ||
        throw(DimensionMismatch("x and z must have the same dimension"))

    # Do Delaunay thingie for sites
    mesh = Delaunay.delaunay(hcat(x, y))

    _M = zeros(T, size(mesh.simplices, 1))
    _θ = similar(_M)
    _X = similar(_M)
    _Y = similar(_M)

    for i in 1:size(mesh.simplices, 1)
        c = hcat(x, y)[mesh.simplices[i, :], :]
        _x = c[:, 1]
        _y = c[:, 2]
        _z = z[mesh.simplices[i, :]]
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
the bidings for `SimpleSDMLayers`, this conversion will be performed
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
wombling(m::Matrix{T}) where {T<:Number} = wombling(convert.(T, 1:size(m,1)), convert.(T, 1:size(m,2)), m)
