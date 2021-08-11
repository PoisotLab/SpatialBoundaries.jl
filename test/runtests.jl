global anyerrors = false

tests = [
   "all good" => "00_allgood.jl"
   "linear gradient" => "01_gradient.jl"
]

for test in tests
   try
      include(joinpath("units", test.second)
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