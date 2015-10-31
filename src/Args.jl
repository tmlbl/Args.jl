__precompile__(true)

module Args

export Command,
       Flag,
       Arguments,
       indexin,
       exec

typealias Arguments Array{UTF8String,1}

import Base.indexin

indexin(args::Arguments, arg::AbstractString) = begin
  arg = utf8(arg)
  ix = 0
  for (i, a) in enumerate(args)
    if a == arg
      ix = i
    end
  end
  ix
end

type Signature
  names::Arguments
  args::Arguments
end

Signature() = Signature(Arguments(), Arguments())

function sig(str::AbstractString)
  brack = findin(str, "[")
  sign = Signature()
  if length(brack) > 0
    name = str[1:(brack[1] - 1)]
    for (o, c) in zip(brack, findin(str, "]"))
      push!(sign.args, strip(utf8(str[(o + 1):(c - 1)])))
    end
  else
    name = str
  end
  sign.names = Arguments(filter((x) -> x != "", map((s) ->
      strip(utf8(s)), split(name, ' '))))
  sign
end

type Command
  action::Function
  names::Arguments
  help::AbstractString
  arguments::Arguments
end

Command(action, signature, help) = begin
  s = sig(signature)
  Command(action, s.names, help, s.args)
end

function parse(c::Command, args::Arguments)
  nargs = Arguments()
  res = Dict{Symbol,Any}()
  found = false
  for n in c.names
    for (ix, a) in enumerate(args)
      if n == a
        found = true
        for (ai, arg) in enumerate(c.arguments)
          res[symbol(arg)] = args[ix + ai]
        end
      end
    end
  end
  found ? res : nothing
end

function exec(c::Command, args::Arguments)
  p = parse(c, args)
  if p != nothing
    c.action(p)
  end
end

function exec(cmds::Array{Command,1}, args::Arguments)
  for c in cmds
    exec(c, args)
  end
end

end # module
