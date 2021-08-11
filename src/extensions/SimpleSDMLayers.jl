function wombling(layer::T; convert_to::Type=Float64) where {T <: SimpleSDMLayer}
    try
        nan = convert(NaN, convert_to)
    catch e
        throw(ArgumentError("The type given as `convert_to` must have a `NaN` value."))
    end

    # Get the values for x and y
    x = collect(longitudes(layer))
    y = collect(latitudes(layer))

    # Get the grid
    z = convert(Matrix{Union{Nothing,convert_to}}, layer.grid)
    replace!(z, nothing => nan)
    return wombling(x, y, convert(Matrix{convert_to}, z))
end
