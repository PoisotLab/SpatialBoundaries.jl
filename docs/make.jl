using Documenter
using SpatialBoundaries
using Literate

# Generate the vignettes using Literate
vignettes_dir = joinpath("src", "vignettes")
for vignette in readdir(vignettes_dir)
    Literate.markdown(joinpath(vignettes_dir, vignettes), vignettes_dir)
end

makedocs(
    sitename = "SpatialBoundaries",
    format = Documenter.HTML(),
    modules = [SpatialBoundaries],
    pages = [
        "Home" => "index.md",
        "Vignettes" => [
            "Linear gradient" => "vignettes/lineargradient.md"
        ]
    ]
)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/EcoJulia/SpatialBoundaries.jl.git",
    devbranch="main",
    push_preview=true
)