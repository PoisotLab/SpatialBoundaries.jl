"""
    boundaries(W::Womble, t=0.1; ignorezero=false)

Extracts candidate boundaries using calculated wombling object `W` on specified
threshold `t`. Default threshold is 0.1, meaning that the top 10% of pixels are
selected as part of the boundaries. This function returns a list of indices
identifying which simplices are part of the boundaries. The NaN values in the
rates of change are not going to be a part of the boundaries. The keyword
`ignorezero`, which defaults to `false`, can be used to remove the points with
a rate of change of 0.
"""
function boundaries(W::T, t=0.1; ignorezero=false) where {T <: Womble}
    #The threshold must be in ]0,1]
    @assert 0.0 < t <= 1.0
    # Remove the NaN values from the rate object
    v = filter(!isnan, W.m)
    # The zeros get removed IFF we require it
    if ignorezero
        filter!(!iszero, v)
    end
    # This is the quantile function
    qf = StatsBase.ecdf(v)
    # We return the positions for which quantile is larger than 1 minus the threshold
    return findall(x -> x > (1.0 - t), qf.(W.m))
end
