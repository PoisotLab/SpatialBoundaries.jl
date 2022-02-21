function _quantizer(x)
    v = filter(!isnan, x)
    return StatsBase.ecdf(v)
    # TODO what's up with 0?
end

"""
    boundaries(W::TriangulationWomble{T}; threshold::T=0.1) where {T <: Number}

Extracts candidate boundaries using calculated rates of change (M) on specified
threshold. Default threshold is 10%, meaning that the top 10% of pixels are
selected as part of the boundaries. This function returns a list of indices
identifying which simplices are part of the boundaries. The NaN values in the
rates of change are not going to be a part of the boundaries.
"""
function boundaries(W::TriangulationWomble{T}; threshold::T=0.1) where {T<:Number}
    @assert 0.0 < threshold <= 1.0
    limit = floor(Int, length(W.m) * threshold)
    nans = count(isnan, W.m)
    return findall(nans .< denserank(W; rev=true) .<= (limit+nans))
end

"""
    boundaries(W::LatticeWomble{T}; threshold::T=0.1) where {T<:Number}

Extracts candidate boundaries using calculated rates of change (M) on specified
threshold. Default threshold is 10%, meaning that the top 10% of pixels are
selected as part of the boundaries. This function returns an array of Cartesian
indices corresponding to the rate of change matrix, indicating which positions
are part of the boundaries. The NaN values in the rates of change are not going
to be a part of the boundaries.
"""
function boundaries(W::LatticeWomble{T}; threshold::T=0.1) where {T<:Number}
    @assert 0.0 < threshold <= 1.0
    limit = floor(Int, size(W.m, 2) * size(W.m, 1) * threshold)
    nans = count(isnan, W.m)
    return findall(nans .< denserank(W; rev=true) .<= (limit+nans))
end
