defmodule Types.Chromosome do
  @enforce_keys :genes
  defstruct [:genes, size: 0, fitness: 0, age: 0]
end
