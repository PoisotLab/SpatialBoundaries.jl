using Documenter
using SpatialBoundaries
using Literate

@info "Prepare to compile"
vignettes_dir = joinpath("docs", "src", "vignettes")
for vignette in readdir(vignettes_dir)
    if occursin(".jl", vignette)
        Literate.markdown(joinpath(vignettes_dir, vignette), vignettes_dir; credit = false)
    end
end

@info "Prepare to build"
makedocs(;
    sitename = "SpatialBoundaries",
    format = Documenter.HTML(),
    modules = [SpatialBoundaries],
    pages = [
        "Home" => [
            "Introduction" => "vignettes/introduction.md",
            "SpatialBoundaries.jl" => "index.md",
        ],
        "Vignettes" => [
            "Finding boundaries" => "vignettes/boundaries.md",
            "Triangulation wombling" => "vignettes/triangulation.md",
            "SDM Layers" => "vignettes/simplesdmlayers.md",
        ],
    ],
)

@info "Prepare to remove"
run(`find . -type f -name ".tif" -delete`)
run(`find . -type f -name ".tif"`)

@info "Prepare to deploy"
deploydocs(;
    deps = Deps.pip("pygments", "python-markdown-math"),
    repo = "github.com/PoisotLab/SpatialBoundaries.jl.git",
    push_preview = true,
    devbranch = "main",
)