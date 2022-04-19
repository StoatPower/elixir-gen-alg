defmodule Cargo do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = for _ <- 1..10, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 10}
  end

  @impl true
  def fitness_function(chromosome) do
    profits = [6, 5, 8, 9, 6, 7, 3, 1, 2, 6]
    weights = [10, 6, 8, 7, 10, 9, 7, 11, 6, 8]
    weight_limit = 40

    potential_profits =
      chromosome.genes
      |> Enum.zip(profits)
      |> Enum.map(fn {c, p} -> c * p end)
      |> Enum.sum()

    over_limit? =
      chromosome.genes
      |> Enum.zip(weights)
      |> Enum.map(fn {c, w} -> c * w end)
      |> Enum.sum()
      |> Kernel.>(weight_limit)

    profits = if over_limit?, do: 0, else: potential_profits
    profits
  end

  @impl true
  def terminate?(_, generation, _), do:
    generation == 1000

end

solution = Genetic.run(Cargo, population_size: 50)

IO.write("\n")
IO.inspect(solution)

weight =
  solution.genes
  |> Enum.zip([10, 6, 8, 7, 10, 9, 7, 11, 6, 8])
  |> Enum.map(fn {g, w} -> w * g end)
  |> Enum.sum()

IO.write("\nWeight is: #{weight}\n")
