"""
    _rate_gradient(∂X, ∂Y)

Returns the rate of change in units of the values stored in the grid, and the
angle of the change in wind direction, *i.e.* an angle of 180 means that the
value is increasing *from* the south. When both ∂X and ∂Y are equal to 0, the
angle is assumed to be 0.
"""
function _rate_gradient(∂X::T, ∂Y::T) where {T<:Number}
    if ∂X == ∂Y == 0.0
        return (0.0, 0.0)
    end
    m = sqrt(∂X^2 + ∂Y^2)
    Δ = ∂X >= 0.0 ? 0.0 : 180.0
    θ = rad2deg(atan(∂X, ∂Y)) + Δ
    θ = ∂X > 0.0 ? θ+180.0 : θ
    return (m, θ)
end

"""
    _rateofchange(x::Vector{T}, y::Vector{T}, z::Vector)

Rate of change for a series of three points, defined as a series of `x` and `y`
coordinates and a value `z`. Returns a rate of change (in units of `z`) and a
gradient in degrees.
"""
function _rateofchange(x::Vector{T}, y::Vector{T}, z::Vector) where {T<:Number}

    # Check that all three vectors have the same length
    length(x) == length(y) || throw(DimensionMismatch("x and y must have the same length"))
    length(x) == length(z) || throw(DimensionMismatch("x and z must have the same length"))

    # Get the matrix of coefficients
    C = cat(y, x, fill(one(T), length(x)); dims=(2, 2))
    coeff = Base.inv(C) * z

    X = sum(C[:, 1]) / 3.0
    Y = sum(C[:, 2]) / 3.0

    ∂X = coeff[2] * Y + coeff[3]
    ∂Y = coeff[1] * X + coeff[3]

    # Rate of change and direction
    return _rate_gradient(∂X, ∂Y)
end

"""
    _rateofchange(A::Matrix{T}) where {T <: Number}

Returns the rate of change and the gradient for a 2x2 grid of numbers.
"""
function _rateofchange(A::Matrix{T}; X=0.5, Y=0.5) where {T<:Number}
    size(A) == (2, 2) || throw(DimensionMismatch("the matrix A must have size (2,2)"))

    # We can get the values directly from the matrix
    Z₄, Z₁, Z₃, Z₂ = A

    ∂X = Z₂ - Z₁ + Y*(Z₁ - Z₂ + Z₃ - Z₄)
    ∂Y = Z₄ - Z₁ + X*(Z₁ - Z₂ + Z₃ - Z₄)

    # Rate of change and direction
    return _rate_gradient(∂X, ∂Y)
end
