"""
    Wombling(x::Vector{T}, y::Vector{T}, z::Vector) where {T<:Number}

Wrapper function that implements the triangualtion wombling algorithm for points 
that are irregularly arranged in space.
"""
function Wombling(x::Vector{T}, y::Vector{T}, z::Vector) where {T<:Number}
    length(x) >= 3  || throw(DimensionMismatch("x must have a minimum length of 3"))

    # Do Delaunay thingie for sites
    mesh = delaunay(hcat(x, y))

    _𝑀 = Vector{Float64}(undef, size(mesh.simplices, 1))
    _Θ = copy(_𝑀)
    _X = copy(_𝑀)
    _Y = copy(_𝑀)

    for i in 1:size(mesh.simplices, 1)
        c = hcat(x, y)[mesh.simplices[i, :], :]
        _x = c[:, 1]
        _y = c[:, 2]
        _z = z[mesh.simplices[i, :]]
        _𝑀[i] = _rateofchange(_x, _y, _z)[1]
        _Θ[i] = _rateofchange(_x, _y, _z)[2]
        _X[i] = sum(c[:, 1]) / 3.0
        _Y[i] = sum(c[:, 2]) / 3.0
    end

    # Rate of change and direction
    return DataFrame(𝑀 = _𝑀, Θ = _Θ, Long = _X, Lat = _Y)
end