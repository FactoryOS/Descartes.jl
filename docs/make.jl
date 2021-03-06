using Documenter
using Descartes

makedocs(
    sitename = "Descartes",
    format = :html,
    modules = [Descartes],
    authors = "Steve Kelly",
    pages = ["Primitives" => "primitives.md",
             "Design" => "design.md"]
)


deploydocs(
    repo = "github.com/sjkelly/Descartes.jl.git"
)
