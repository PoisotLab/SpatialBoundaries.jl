global anyerrors = false

tests = [
   "mock test" => "00_allgood.jl",
   "Linear gradient" => "01_gradient.jl",
   "Boundaries detection" => "02_boundaries.jl",
   "REQUIRE: SimpleSDMLayers" => "R1_simplesdmlayers.jl"
]

for test in tests
   try
      include(joinpath("units", test.second))
      println("\033[1m\033[32m✓\033[0m\t$(test.first)")
   catch e
      global anyerrors = true
      println("\033[1m\033[31m×\033[0m\t$(test.first)")
      println("\033[1m\033[38m→\033[0m\ttest/$(test.second)")
      showerror(stdout, e, backtrace())
      println()
      break
   end
end

if anyerrors
   throw("Tests failed")
end