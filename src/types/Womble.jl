abstract type Womble end

mutable struct TriangulationWomble{T <: Number} <: Womble
    m::Vector{T}
    θ::Vector{T}
    x::Vector{T}
    y::Vector{T}
end

mutable struct LatticeWomble{T <: Number} <: Womble
    m::Matrix{T}
    θ::Matrix{T}
    x::Vector{T}
    y::Vector{T}
end

function StatsBase.denserank(tw::T; kw...) where {T <: TriangulationWomble}
    return StatsBase.denserank(tw.m; kw...)
end