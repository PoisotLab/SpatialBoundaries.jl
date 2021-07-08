"""
    Boundaries(𝑀::Matrix{Union{Nothing, Float32}}; threshold::Float32=0.1)

Extracts candidate boundaries using calculated rates of change (𝑀) on specified 
threshold. Default threshold is 10%.
"""
function Boundaries(𝑀::Matrix{Union{Nothing, Float32}}; threshold=0.1)

    𝑀 = 𝑀
    thresh = threshold
    rank = floor(Int, size(𝑀, 2)*size(𝑀, 1)*thresh)
    𝑀_n = denserank(replace(𝑀 , nothing => missing), #need to use type::missing
                    rev=true) # ranks largest to smallest

    replace!(x -> isless(x, rank) ? 1 : missing, 𝑀_n) # assigns all in above threshold to 1

    # Rate of change and direction
    return replace(𝑀_n , missing => nothing) #back to type::nothing to play with SDMSimple
end