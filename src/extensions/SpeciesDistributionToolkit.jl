"""
    wombling(layer::SDMLayer; convert_to::Type=Float64)

Performs a lattice wombling on a `SimpleSDMLayer`.
"""
function wombling(layer::SDMLayer)
    
    # Get the values for x and y
    y = collect(SimpleSDMLayers.eastings(layer))
    x = collect(SimpleSDMLayers.northings(layer))

    # Get the grid
    z = convert(Matrix{Float64}, layer.grid)
    z[findall(!, layer.indices)] .= NaN

    # Womble
    W = wombling(Float64.(x), Float64.(y), z)

    # Prepare to return
    rate = SimpleSDMLayers.SDMLayer(W.m, (!isnan).(W.m), extrema(W.y), extrema(W.x), layer.crs)
    direction = SimpleSDMLayers.SDMLayer(W.θ, (!isnan).(W.m), extrema(W.y), extrema(W.x), layer.crs)
    return (; rate, direction)
end
