defmodule OneMax do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = for _ <- 1..5, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 5}
  end

  @impl true
  def fitness_function(chromosome) do
    IO.inspect(chromosome)
    fit = IO.gets("Rate from 1 to 10: ")
    fit |> String.trim |> String.to_integer()
  end

  @impl true
  def terminate?(_, generation, _temperature), do: generation == 2
end

solution = Genetic.run(OneMax, population_size: 2)

IO.write("\n")
IO.inspect(solution)
