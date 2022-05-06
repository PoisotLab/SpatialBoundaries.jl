"""
Statistics.mean(w::Vector{T}) where {T <: Womble}

Function that calculates the mean wombling value for a vector of wombled layers
of type Womble that occupy the same spatial area.
"""
function Statistics.mean(w::Vector{T}) where {T<:Womble}
    # Check that all wombles have the same dimensions and coordinates
    @assert all([w1.x == w2.x for w1 in w, w2 in w])
    @assert all([w1.y == w2.y for w1 in w, w2 in w])
    @assert all([size(w1.m) == size(w2.m) for w1 in w, w2 in w])
    # Prepare the matrices
    m = fill(NaN, size(w[1].m))
    α = fill(NaN, size(w[1].m))
    # Fill the matrices
    for _idx in eachindex(w[1].m)
        ch = filter(!isnan, [womble.m[_idx] for womble in w])
        di = filter(!isnan, [deg2rad(womble.θ[_idx]) for womble in w])
        if !isempty(ch)
            m[_idx] = mean(ch)
            α[_idx] = atan(mean(sin.(di)), mean(cos.(di)))
        end
    end
    average_direction = rad2deg.(α) .+ 180.0
    if isa(w[1], LatticeWomble)
        return LatticeWomble(m, average_direction, w[1].x, w[1].y)
    end
    if isa(w[1], TriangulationWomble)
        return TriangulationWomble(m, average_direction, w[1].x, w[1].y)
    end
end