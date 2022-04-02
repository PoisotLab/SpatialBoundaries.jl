"""
    omlwv(w::Vector{T}) where {T <: LatticeWombling}

Overall Mean Lattice-Wombling Value, as in Fortin 1994
"""
function omlwv(w::Vector{T}) where {T<:LatticeWomble}
    # TODO assert that the coordinates are the same!
    m = [layer.m for layer in w]
    α = [deg2rad.(layer.θ) for layer in w]
    average_change = reduce(.+, m) ./ length(w)
    sin_comp = reduce(.+, sin.(α)) ./ length(w)
    cos_comp = reduce(.+, cos.(α)) ./ length(w)
    average_angle = atan.(sin_comp, cos_comp)
    average_direction = rad2deg.(average_angle) .+ 180.0
    return LatticeWomble(average_change, average_angle, w[1].x, w[1].y)
end