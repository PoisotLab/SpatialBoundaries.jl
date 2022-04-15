"""
    omlwv(w::Vector{T}) where {T <: Womble}

Overall Mean Lattice-Wombling Value, as in Fortin 1994
"""
function omlwv(w::Vector{T}) where {T<:Womble}
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
    return MeanWomble(m, average_direction, w[1].x, w[1].y)
end