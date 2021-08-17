using Documenter
using SpatialBoundaries
using Literate

# Generate the vignettes using Literate
vignettes_dir = joinpath("docs", "src", "vignettes")
for vignette in readdir(vignettes_dir)
    Literate.markdown(joinpath(vignettes_dir, vignette), vignettes_dir; credit=false)
end

makedocs(
    sitename = "SpatialBoundaries",
    format = Documenter.HTML(),
    modules = [SpatialBoundaries],
    pages = [
        "Home" => "index.md",
        "Vignettes" => [
            "Introduction" => "vignettes/introduction.md",
            "Finding boundaries" => "vignettes/boundaries.md",
            "SDM Layers" => "vignettes/simplesdmlayers.md"
        ]
    ]
)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/EcoJulia/SpatialBoundaries.jl.git",
    devbranch="main",
    push_preview=true
)