defmodule Toolbox.Selection do
  @moduledoc """
  A toolbox of chromosome selection strategies.
  """

  @doc """
  Elitism selection strategy.

  Prefers the most elite chromosomes. Doesn't factor genetic diversity into
  the mix at all.

  Pros: Fast and simple
  Cons: Can lead to premature convergence

  Pair with stronger mutation, larger populations, or larger chromosomes to
  help counteract the lack of diversity in selection.
  """
  def elite(population, n) do
    population
    |> Enum.take(n)
  end

  @doc """
  Random selection strategy.

  Selects a completely random sample of chromsomes. Doesn't consider fitness at all.

  Pros: Useful when problem absolutely requires genetic diversity
  Cons: Does not consider fitness of chromosomes for selection

  Less commonly used, but can be useful for *novelty search* and *scenario generation*
  problems.
  """
  def random(population, n) do
    population
    |> Enum.take_random(n)
  end

  @doc """
  Tournament selection strategy using duplicates.

  Pits chromosomes against one another in a tournament. Selections are still
  based on fitness, but tournament selection introduces a strategy to choose
  parents that are both diverse and strong. Tournament size affects the balance
  of selected parents.

  Pros:
    Useful for balancing both fitness and diveristy.
    Works well in parallel.
    Much faster than disallowing duplicates.
  Cons:
    Might not be appropriate for smaller populations.
    Risk of allowing population to become less genetically diverse compared
    to disallowing duplicates.
  """
  def tournament(population, n, tournament_size) do
    0..(n - 1)
    |> Enum.map(&tournament_selector/2)
  end

  @doc """
  Tournament selection strategy without using duplicates.

  Pits chromosomes against one another in a tournament. Selections are still
  based on fitness, but tournament selection introduces a strategy to choose
  parents that are both diverse and strong. Tournament size affects the balance
  of selected parents.

  Pros:
    Useful for balancing both fitness and diveristy.
    Works well in parallel.
    More genetic diversity than allowing duplicates.
  Cons:
    Might not be appropriate for smaller populations.
    Much slower than allowing duplicates.
  """
  def tournament_no_duplicates(population, n, tournament_size) do
    selected = MapSet.new()
    tournament_no_dupes_helper(population, n, tournament_size, selected)
  end

  defp tournament_no_dupes_helper(population, n, tournament_size, selected) do
    if MapSet.size(selected) == n do
      MapSet.to_list(selected)
    else
      chosen =
        population
        |> tournament_selector(tournament_size)

      tournament_no_dupes_helper(population, n, tournament_size, MapSet.put(selected, chosen))
    end
  end

  defp tournament_selector(population, tournament_size) do
    population
    |> Enum.take_random(tournament_size)
    |> Enum.max_by(& &1.fitness)
  end

  @doc """
  Roulette selection chooses parents with a probability proportional to their fitness.any()
  Attempts to balance genetic diversity and fitness based on probability.

  Pros:
    Excellent at maintaining the fitness of a population while including some diverse parents
  Cons:
    By far the slowest strategy compared to others above.

  Try tournament selection first.
  """
  def roulette(chromosomes, n) do
    # calculate the total fitness of the population.
    # necessary to determine the proportion of the roulette wheel each chromosome will occupy
    sum_fitness =
      chromosomes
      |> Enum.map(& &1.fitness)
      |> Enum.sum()

    # select `n` individuals
    0..(n - 1)
    |> Enum.map(fn _ ->
      # calculate random value `u`, representing one spin of the wheel
      u = :rand.uniform() * sum_fitness

      # loop over individuals in the population until you're within the selected area, upon
      # which you stop the reduction and return the selection
      chromosomes
      |> Enum.reduce_while(
        0,
        fn x, sum ->
          if x.fitness + sum > u do
            {:halt, x}
          else
            {:cont, x.fitness + sum}
          end
        end
      )
    end)
  end
end
