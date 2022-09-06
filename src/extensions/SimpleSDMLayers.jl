"""
    wombling(layer::T; convert_to::Type=Float64) where {T <: SimpleSDMLayer}

Performs a lattice wombling on a `SimpleSDMLayer`.
"""
function wombling(layer::T; convert_to::Type = Float64) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    try
        global nan = convert(convert_to, NaN)
    catch
        throw(ArgumentError("The type given as `convert_to` must have a `NaN` value."))
    end

    # Get the values for x and y
    y = collect(SimpleSDMLayers.longitudes(layer))
    x = collect(SimpleSDMLayers.latitudes(layer))

    # Get the grid
    z = convert(Matrix{Union{Nothing, convert_to}}, layer.grid)
    replace!(z, nothing => nan)
    return wombling(x, y, convert(Matrix{convert_to}, z))
end

# We want to make sure that the layers are returned without NaN values, and
# adding this method makes the code easier to write
Base.isnan(::Nothing) = false

function SimpleSDMLayers.SimpleSDMPredictor(W::T) where {T <: LatticeWomble}
    rate = SimpleSDMLayers.SimpleSDMPredictor(W.m, extrema(W.y)..., extrema(W.x)...)
    direction = SimpleSDMLayers.SimpleSDMPredictor(W.θ, extrema(W.y)..., extrema(W.x)...)
    rate.grid[findall(isnan, rate.grid)] .= nothing
    direction.grid[findall(isnan, direction.grid)] .= nothing
    return (rate, direction)
end

function SimpleSDMLayers.SimpleSDMResponse(W::T) where {T <: LatticeWomble}
    return convert.(SimpleSDMLayers.SimpleSDMResponse, SimpleSDMLayers.SimpleSDMPredictor(W))
end
