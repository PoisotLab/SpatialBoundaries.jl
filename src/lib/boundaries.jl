"""
    boundaries(W::TriangulationWomble{T}; threshold::T=0.1) where {T <: Number}

Extracts candidate boundaries using calculated rates of change (M) on specified
threshold. Default threshold is 10%, meaning that the top 10% of pixels are
selected as part of the boundaries.
"""
function boundaries(W::TriangulationWomble{T}; threshold::T=0.1) where {T<:Number}
    limit = floor(Int, length(W.m) * threshold)

    changerank = findall(denserank(W; rev=true) .<= limit)

    candidate_boundaries = hcat(W.x[changerank], W.y[changerank], W.m[changerank])

    return candidate_boundaries
end

"""
    boundaries(M::Matrix{Union{Nothing, Float32}}; threshold::Float32=0.1)

Extracts candidate boundaries using calculated rates of change (M) on specified
threshold. Default threshold is 10%, meaning that the top 10% of pixels are
selected as part of the boundaries.
"""
function boundaries(W::LatticeWomble{T}; threshold::T=0.1) where {T<:Number}
    limit = floor(Int, size(W.m, 2) * size(W.m, 1) * threshold)
    changerank = findall(denserank(W; rev=true) .<= limit)

    z_values = W.m[changerank]
    x_values = [W.x[r.I[1]] for r in changerank]
    y_values = [W.y[r.I[2]] for r in changerank]

    candidate_boundaries = hcat(x_values, y_values, z_values)

    return candidate_boundaries
end
