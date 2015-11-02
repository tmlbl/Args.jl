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

abstract ArgElement

type Command <: ArgElement
  action::Function
  names::Arguments
  help::AbstractString
  arguments::Arguments
end

type Flag <: ArgElement
  names::Arguments
  help::AbstractString
  arguments::Arguments
end

typealias ArgTable Array{ArgElement,1}

Command(action, signature, help) = begin
  s = sig(signature)
  Command(action, s.names, help, s.args)
end

Flag(signature, help) = begin
  s = sig(signature)
  Flag(s.names, help, s.args)
end

function parse(c::ArgElement, args::Arguments)
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
  arglen = length(c.arguments)
  if found && length(res) < arglen
    error("'$(c.names[1])' takes $(length(c.arguments)) argument$(arglen != 1 ? 's' : "")")
  end
  found ? res : nothing
end

function parse(c::ArgElement, args::Arguments, res::Dict{Symbol,Any})
  p = parse(c, args)
  if typeof(c) == Flag
    for (k, v) in p
      res[k] = v
    end
  end
  res
end

function exec(c::ArgElement, args::Arguments)
  p = parse(c, args)
  if p != nothing
    if length(c.arguments) > 0
      c.action(p)
    else
      c.action()
    end
  end
end

function exec(cmds::AbstractArray, args::Arguments)
  res = Dict{Symbol,Any}()
  exec_cmd = () -> nothing
  for c in cmds
    parse(c, args, res)
    p = parse(c, args)
    if p != nothing && typeof(c) == Command
      exec_cmd = c
    end
  end
  if exec_cmd != nothing && length(exec_cmd.arguments) > 0
    exec_cmd.action(res)
  else
    exec_cmd.action()
  end
end

end # module
