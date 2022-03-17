defmodule OneMax3 do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = for _ <- 1..42, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl true
  def fitness_function(chromosome), do: Enum.sum(chromosome.genes)

  @impl true
  def terminate?(population, _) do
    Enum.max_by(population, &OneMax3.fitness_function/1).fitness == 42
  end

  # Minimum Fitness Threshold
  # @impl true
  # def terminate?(population), do:
  #   Enum.min_by(population, &OneMax3.fitness_function/1).fitness == 0

  # Average Fitness Threshold
  # @impl true
  # def terminate?(population) do
  #   sum =
  #     population
  #     |> Enum.map(&(&1.fitness))
  #     |> Enum.sum

  #   IO.inspect("Sum: #{sum}")

  #   avg =
  #     sum / length(population)
  #     # |> Enum.map(&(Enum.sum(&1.fitness) / length(population)))

  #   IO.inspect("Avg: #{avg}")

  #   avg == 21
  # end
end

solution = Genetic.run(OneMax3)

IO.write("\n")
IO.inspect(solution)
