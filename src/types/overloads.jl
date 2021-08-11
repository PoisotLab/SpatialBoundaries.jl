function StatsBase.denserank(W::T; kw...) where {T <: Womble}
    return StatsBase.denserank(W.m; kw...)
end