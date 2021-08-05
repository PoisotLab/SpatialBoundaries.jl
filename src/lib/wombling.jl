"""
    wombling(x::Vector{T}, y::Vector{T}, z::Vector) where {T<:Number}

Wrapper function that implements the triangulation wombling algorithm for points
that are irregularly arranged in space.
"""
function wombling(x::Vector{T}, y::Vector{T}, z::Vector{T}) where {T<:Number}
    
    length(x) >= 3  || throw(DimensionMismatch("x must have a minimum length of 3"))
    length(x) == length(y) || throw(DimensionMismatch("x and y must have the same dimension"))
    length(x) == length(z) || throw(DimensionMismatch("x and z must have the same dimension"))

    # Do Delaunay thingie for sites
    mesh = delaunay(hcat(x, y))

    _M = Vector{Float64}(undef, size(mesh.simplices, 1))
    _Θ = copy(_M)
    _X = copy(_M)
    _Y = copy(_M)

    for i in 1:size(mesh.simplices, 1)
        c = hcat(x, y)[mesh.simplices[i, :], :]
        _x = c[:, 1]
        _y = c[:, 2]
        _z = z[mesh.simplices[i, :]]
        _M[i], _Θ[i] = _rateofchange(_x, _y, _z)
        _X[i] = sum(c[:, 1]) / 3.0
        _Y[i] = sum(c[:, 2]) / 3.0
    end

    # Rate of change and direction
    return (M = _M, Θ = _Θ, x = _X, y = _Y)
end

"""
    wombling(A::Matrix{T}) where {T<:Number}

Wrapper function that implements the lattice wombling algorithm for points
that are regularly arranged in space.
"""
function wombling(A::Matrix{T}) where {T<:Number}
    
    _𝑀 = convert(Matrix{Union{Float32}}, zeros(Float32, size(A) .- 1)) #empty matrix to fill
    _Θ = copy(_M)

    for j in 1:size(_M, 2), i in 1:size(_M, 1) #womble along a 2x2 window
        tmp = A[i:(i + 1), j:(j + 1)]
            _𝑀[i, j], _Θ[i, j] = _rateofchange(tmp)
    end

    # Rate of change and direction
    return DataFrame(𝑀 = _𝑀, Θ = _Θ)
end