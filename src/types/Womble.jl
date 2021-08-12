abstract type Womble end

"""
    TriangulationWomble{T <: Number} <: Womble

A set of data (and co-ordinates) that are irregularly arranged
in space are of type `TriangulationWomble` after having been
passed through `wombling`
"""
mutable struct TriangulationWomble{T <: Number} <: Womble
    m::Vector{T}
    θ::Vector{T}
    x::Vector{T}
    y::Vector{T}
end

"""
    LatticeWomble{T <: Number} <: Womble

A set of data (and co-ordinates) that are regularly arranged
in space are of type `LatticeWomble` after having been
passed through `wombling`
"""
mutable struct LatticeWomble{T <: Number} <: Womble
    m::Matrix{T}
    θ::Matrix{T}
    x::Vector{T}
    y::Vector{T}
end