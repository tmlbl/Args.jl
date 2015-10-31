__precompile__(true)

module Args

export Command,
       Flag,
       Arguments,
       indexin

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

type Command
  action::Function
  names::Arguments
  help::AbstractString
  arguments::Int64
end

type Flag
  action::Function
  short::Char
  long::UTF8String
  help::AbstractString
  arguments::Int64
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
  sign.names = Arguments(map((s) -> strip(utf8(s)), split(name, ',')))
  sign
end

function sig(c::Command)

end

function sig(f::Flag)

end

function help(c::Command)

end

function help(f::Flag)

end

function parse(args::Arguments)

end

function parse(c::Command, args::Arguments)
  nargs = Arguments()
  for (i, a) in enumerate(args)
    if c.name == a
      if c.arguments > 0
        for ix = (i + 1):(i + c.arguments)
          if length(args) < ix
            print_with_color(:red, c.help)
            error("Command $(c.long) takes $(c.arguments) argument$(c.arguments > 1 ? s : ' ')")
          else
            push!(nargs, args[ix])
          end
        end
      end
      return nargs
    end
  end
end

end # module
