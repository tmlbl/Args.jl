using Args,
      FactCheck

facts("Utils") do
  @fact indexin(Arguments(["exec", "plop", "dome"]), "plop") --> 2
  context("Parse command signature") do
    @fact Args.sig("plop").names --> Arguments(["plop"])
    @fact Args.sig("plop [dop]").names --> Arguments(["plop"])
    @fact Args.sig("plop [dop]").args --> Arguments(["dop"])
  end
  context("Parse flag signature") do

  end
end

# facts("Command") do
#   plop = Command("plop [area]", """
# Plop command: plot a Dollop on your top
#   """) do args
#     @show args
#   end
#
#   @fact Args.parse(plop, Arguments(["exec", "plop", "dome"])) --> Arguments(["dome"])
#   @fact Args.parse(plop, Arguments(["exec", "plot"])) --> nothing
#   @fact_throws Args.parse(plop, Arguments(["exec", "plop"]))
#
# end
#
# facts("Flag") do
#   flg = Flag("-p, --peanuts [type]", """
# The circus must be in town!
#   """) do args
#     @show args
#   end
#
#   @fact Args.parse(flg, Arguments(["exec", "--peanuts", "bag"])) --> Arguments(["bag"])
#   @fact_throws Args.parse(flg, Arguments(["exec", "-p"]))
#   @fact Args.parse(flg, Arguments(["exec", "-p", "shells"])) --> Arguments(["shells"])
#   @fact Args.parse(flg, Arguments(["exec"])) --> false
#   @fact_throws Args.parse(flg, Arguments(["exec", "--peanuts"]))
# end
