module PSpaces

import GridInterpolations: RectangleGrid, ind2x, interpolants

export
  PSpace,
  RangeSpace,
  ValuesSpace,
  ind2x,
  ind2x!,
  x2ind

abstract Space

type RangeSpace <: Space

  values::Range

  RangeSpace(range::Range) = new(range)
  RangeSpace{T<:Real}(minval::T, maxval::T) = new(minval:maxval)
  RangeSpace{T<:Real}(minval::T, step::T, maxval::T) = new(minval:step:maxval)

end

type ValuesSpace <: Space

  values::Vector

  function ValuesSpace(vector::Vector)
    if isunique(vector)
      new(vector)
    else
      error("Input values need to be unique.")
    end
  end

end

type PSpace

  cutpoints::Vector{Vector{Any}}
  grid::RectangleGrid

  function PSpace(spaces::Space...)
    cutpoints = [collect(spaces[i].values) for i in 1:length(spaces)]
    spaces = [collect(1.0:length(spaces[i].values)) for i in 1:length(spaces)]
    grid = RectangleGrid(spaces...)
    new(cutpoints, grid)
  end

end

function isunique(vector::Vector)
  for i in 1:length(vector)
    for j in i+1:length(vector)
      if vector[i] == vector[j]
        return false
      end
    end
  end
  return true
end

function ind2x(pspace::PSpace, ind::Int)
  x = Array(Any, length(pspace.cutpoints))
  ind2x!(x, pspace, ind)
  return x
end

function ind2x!(x::Vector, pspace::PSpace, ind::Int)
  gridx = ind2x(pspace.grid, ind)
  grid2x!(x, pspace, gridx)
end

function grid2x!(x::Vector, pspace::PSpace, gridx::Vector{Float64})
  intgridx = map(Int64, gridx)
  for i in 1:length(x)
    x[i] = pspace.cutpoints[i][intgridx[i]]
  end
end

# warning: ensure that |x| is a valid vector, otherwise you'll get junk
function x2ind(pspace::PSpace, x::Vector)
  gridx = [Float64(findfirst(pspace.cutpoints[i], x[i])) for i in 1:length(x)]
  # @assert !in(0, gridx)  # gridx[i] = 0.0 if x[i] isn't a valid variable value
  indices, weights = interpolants(pspace.grid, gridx)
  indices[indmax(weights)]
end

end