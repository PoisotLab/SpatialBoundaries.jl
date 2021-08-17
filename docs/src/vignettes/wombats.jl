## Wombling with wombats

using GBIF
using SpatialBoundaries

# we can extract wombat occurence records using `GBIF.jl`

occurrences(
            taxon("Vombatus ursinus", rank = :SPECIES),
            "limit" => 300, "country" => "AU"
            )