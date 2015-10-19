# PSpaces.jl

A convenient Julia package that provides a mapping between discrete values and their indices.

# Installation

Please install [GridInterpolations.jl](https://github.com/sisl/GridInterpolations.jl) before PSpaces.jl. To install this package, type the following on the Julia console.

```julia
julia> Pkg.update()
julia> Pkg.clone("https://github.com/sisl/PSpaces.jl")
```

# Use

## Initializing `PSpace`

```julia
using PSpaces

# define factored spaces
a = RangeSpace(1:10:1020)
b = RangeSpace(20, 302)
c = RangeSpace(5, 2, 100)
d = ValuesSpace(["hello", "world", "who", "am", "i"])

pspace = PSpace(a, b, c, d)
```

## Index from vector

```julia
x = [1, 33, 7, "world"]
ind = x2ind(pspace, x)  # ind = 1415761
```

__Warning:__ Be careful about querying invalid vectors! `x2ind` will simply return a junk index `ind` if `x` is invalid. See the method definition in `[root]/src/PSpaces.jl` [file](https://github.com/sisl/PSpaces.jl/blob/master/src/PSpaces.jl) to see why. We've also added error-checking code that you can use for testing, but remember to comment it out for performance when you're done squashing bugs.

## Vector from index

```julia
ind = 600613
x = ind2x(pspace, ind)  # x = [361 248, 45, "hello"]
```

__Note:__ A BoundsError will result from inputting an invalid index `ind`.
