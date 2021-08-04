"""
    boundaries(M::Matrix{Union{Nothing, Float32}}; threshold::Float32=0.1)

Extracts candidate boundaries using calculated rates of change (M) on specified 
threshold. Default threshold is 10%.
"""
function boundaries(M::Matrix{Union{Nothing,Float32}}; threshold=0.1)

    rank = floor(Int, size(M, 2) * size(M, 1) * threshold)
    M_n = denserank(replace(M, nothing => missing), # need to use type::missing
                    rev=true) # ranks largest to smallest

    replace!(x -> isless(x, rank) ? 1 : missing, M_n) # assigns all in above threshold to 1

    # Rate of change and direction
    return replace(M_n, missing => nothing) # back to type::nothing to play with SDMSimple
end