using SimpleSDMLayers

function wombling(layer::T; convert_to::Type=Float64) where {T <: SimpleSDMLayer}
    try
        global nan = convert(convert_to, NaN)
    catch e
        throw(ArgumentError("The type given as `convert_to` must have a `NaN` value."))
    end

    # Get the values for x and y
    y = collect(longitudes(layer))
    x = collect(latitudes(layer))

    # Get the grid
    z = convert(Matrix{Union{Nothing,convert_to}}, layer.grid)
    replace!(z, nothing => nan)
    return wombling(x, y, convert(Matrix{convert_to}, z))
end
