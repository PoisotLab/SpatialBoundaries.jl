using Documenter
using SpatialBoundaries
using Literate

# Generate the vignettes using Literate
vignettes_dir = joinpath("docs", "src", "vignettes")
for vignette in readdir(vignettes_dir)
    if occursin(".jl", vignette)
        Literate.markdown(joinpath(vignettes_dir, vignette), vignettes_dir; credit=false)
    end
end

makedocs(
    sitename = "SpatialBoundaries",
    format = Documenter.HTML(),
    modules = [SpatialBoundaries],
    pages = [
        "Home" => [
            "Introduction" => "vignettes/introduction.md",
            "SpatialBoundaries.jl" => "index.md"
            ],
        "Vignettes" => [
            "Finding boundaries" => "vignettes/boundaries.md",
            "Triangulation wombling" => "vignettes/triangulation.md",
            "SDM Layers" => "vignettes/simplesdmlayers.md"
        ]
    ]
)

# Remove the geotiffs AFTER Documenter compiles the vignettes
rm("assets/EarthEnv/"; force=true, recursive=true)
rm("assets/WorldClim/"; force = true, recursive = true)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/PoisotLab/SpatialBoundaries.jl.git",
    push_preview=true,
    devbranch="main"
)