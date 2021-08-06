"""
    boundaries(M::Matrix{Union{Nothing, Float32}}; threshold::Float32=0.1)

Extracts candidate boundaries using calculated rates of change (M) on specified
threshold. Default threshold is 10%, meaning that the top 10% of pixels are
selected as part of the boundaries.
"""
function boundaries(M::Matrix{T}; threshold::T=0.1) where {T <: Number}
    limit = floor(Int, size(M, 2) * size(M, 1) * threshold)
    M_n = denserank(M, rev=true) # ranks largest to smallest
    return M_n .< limit
end

"""
    boundaries(M::Vector{Float64}, x::Vector{Float64}, y::Vector{Float64}; threshold::T=0.1) where {T <: Number}

Extracts candidate boundaries using calculated rates of change (M) on specified
threshold. Default threshold is 10%, meaning that the top 10% of pixels are
selected as part of the boundaries.
"""
function boundaries(M::Vector{Float64}, x::Vector{Float64}, y::Vector{Float64}; threshold::T=0.1) where {T <: Number}
    
    limit = floor(Int, length(df.M) * threshold)
    
    v = hcat(denserank(M, rev = true),M, x, y); 
    sort!(v, dims = 1, by = x -> x[1])
    v[(v[:,1] .< limit),:]
    return (B = v[:,2], x = v[:,3], y = v[:,4])
end