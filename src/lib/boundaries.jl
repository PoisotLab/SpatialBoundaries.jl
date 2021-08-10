function StatsBase.denserank(tw::T; kw...) where {T <: TriangulationWomble}
    return StatsBase.denserank(tw.m; kw...)
end


"""
    boundaries(W::TriangulationWomble{T}; threshold::T=0.1) where {T <: Number}

Extracts candidate boundaries using calculated rates of change (M) on specified
threshold. Default threshold is 10%, meaning that the top 10% of pixels are
selected as part of the boundaries.
"""
function boundaries(W::TriangulationWomble{T}; threshold::T = 0.1) where {T<:Number}

    limit = floor(Int, length(W.m) * threshold)

    changerank = findall(denserank(W, rev = true) .<= limit)
    
    candidate_boundaries = hcat(W.x[changerank], W.y[changerank], W.m[changerank])
    sort!(candidate_boundaries, dims=1, by=last, rev=true)
    
    return candidate_boundaries
end

"""
    boundaries(M::Matrix{Union{Nothing, Float32}}; threshold::Float32=0.1)

Extracts candidate boundaries using calculated rates of change (M) on specified
threshold. Default threshold is 10%, meaning that the top 10% of pixels are
selected as part of the boundaries.
"""
function boundaries(M::Matrix{T}; threshold::T = 0.1) where {T<:Number}
    limit = floor(Int, size(M, 2) * size(M, 1) * threshold)
    M_n = denserank(M, rev = true) # ranks largest to smallest
    return M_n .< limit
end
