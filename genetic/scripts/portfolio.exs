defmodule Portfolio do
  @behaviour Problem
  alias Types.Chromosome

  @target_fitness 180

  @doc """
  Generates portfolios of 10 stocks each with ROI and risk scores
  between 0 and 10.
  """
  @impl true
  def genotype do
    genes =
      for _ <- 1..10, do:
        {:rand.uniform(10), :rand.uniform(10)}
    %Chromosome{genes: genes, size: 10}
  end

  @doc """
  ROI is weighted 2x more important than risk.
  """
  @impl true
  def fitness_function(chromosome) do
    chromosome
    |> Enum.map(fn {roi, risk} -> 2 * roi - risk end)
    |> Enum.sum()
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    max_value = Enum.max_by(population, &Portfolio.fitness_function/1)
    max_value > @target_fitness
  end
end
