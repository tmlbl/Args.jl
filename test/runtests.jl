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
    @fact Args.sig("-p").names --> Arguments(["-p"])
    @fact Args.sig("-p --pong").names --> Arguments(["-p", "--pong"])
    @fact Args.sig("--pong [ping]").args --> Arguments(["ping"])
  end
end

facts("Command") do
  state = [0]

  plop = Command("plop [area]", """
Plop command: plot a Dollop on your top
  """) do args
    state[1] = 1
  end
  context("Parses arguments") do
    @fact Args.parse(plop, Arguments(["exec", "plop", "dome"])) --> Dict("area" => "dome")
    # @fact Args.parse(plop, Arguments(["exec", "plot"])) --> nothing
    # @fact_throws Args.parse(plop, Arguments(["exec", "plop"]))
    # Args.exec(plop, Arguments(["exec", "plop", "gyro"]))

  end

  flag = Command("-n --no [scrubs]", """
Pay my bills
  """) do args
    @show args
  end
end
