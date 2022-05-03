defmodule Genetic2 do
  alias Types.Chromosome

  @moduledoc """
  Documentation for `Genetic`.
  """

  @doc """
  Entry point for running a genetic algorithm.

  Follows the following rules:
    * Rule 1 - encodes chromosomes using a data structure supporting collections
    * Rule 2 - works on a population of any size

  ## Examples

    iex> Genetic.run(problem)

  """
  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0, opts)

    population
    |> evolve(problem, 0, 0, 0, opts)
  end

  @doc """
  Recursive evolution function designed to model a single evolution
  in the genetic algorithm.

  ## Examples

    iex> Genetic.evolve(population, problem)

  """
  def evolve(population, problem, generation, last_max_fitness, temperature, opts \\ []) do
    population = evaluate(population, &problem.fitness_function/1, opts)

    best = hd(population)
    best_fitness = best.fitness
    temperature = 0.8 * (temperature + (best_fitness - last_max_fitness))
    IO.write("\rCurrent Best: #{best.fitness}")

    if problem.terminate?(population, generation, temperature) do
      best
    else
      generation = generation + 1

      {parents, leftover} = selection(population, opts)
      # obtain new children by passing parents into crossover
      children = crossover(parents, opts)
      # recombine children with leftover before mutating and continuing evolution
      (children ++ leftover)
      |> mutation(opts)
      # recurse
      |> evolve(problem, generation, best_fitness, temperature, opts)
    end
  end

  @doc """
  Step 1 - Initialize the population.

  Follows the following rules:
    * Rule 3 - produces the initial population
    * Rule 4 - is agnostic to how the chromosomes are encoded
  """
  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  @doc """
  Step 2 - Evaluation of the population.

  Follows the following rules:
    * Rule 5 - takes a population as first input
    * Rule 6 - produces a population sorted on fitness
    * Rule 7 - takes a fitness function as the second input, which
        takes a parameter that is a function that evaluates the fitness
        of each chromosome
    * Rule 8 - the fitness function can return anything, as long as it
        produces a sortable result
  """
  def evaluate(population, fitness_function, opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      fitness = fitness_function.(chromosome)
      age = chromosome.age + 1
      %Chromosome{chromosome | fitness: fitness, age: age}
    end)
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  @doc """
  Step 3 - Selection of parents in population.

  Accepts many different kinds of selection and defaults to `elite/2` which is what
  our initial, naive implementation did. Also accounts for different selection rates.

  Follows the following rules:
    * Rule 9 - takes a population as input
    * Rule 10 - produces a transformed population that easy's to work
        with during crossover
  """
  def selection(population, opts \\ []) do
    select_fn = Keyword.get(opts, :selection_type, &Toolbox.Selection.elite/2)
    select_rate = Keyword.get(opts, :selection_rate, 0.8)

    # `n` is the number of parents to select
    # the associated logic just ensures you have enough parents to make even pairs
    n = round(length(population) * select_rate)
    n = if rem(n, 2) == 0, do: n, else: n + 1

    # extract the parents using `apply/2` and the chosen selection strategy
    parents =
      select_fn
      |> apply([population, n])

    # determine who wasn't selected with the help of MapSet
    leftover =
      population
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(parents))

    # turn the parents into tuples for corssover
    parents =
      parents
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple(&1))

    {parents, MapSet.to_list(leftover)}
  end

  @doc """
  Step 4 - Crossover: recombine selected parents into new children

  Accepts many types of crossover defaulting to our `naive` function

  Follows the following rules:
    * Rule 11 - takes a list of parents as input
    * Rule 12 - recombines the list of parents using a crossover function
    * Rule 13 - returns a population of the same size as input population
  """
  def crossover(population, opts \\ []) do
    crossover_fn = Keyword.get(opts, :crossover_type, &Toolbox.Crossover.naive/2)

    population
    |> Enum.reduce(
      [],
      fn {p1, p2}, acc ->
        {c1, c2} = apply(crossover_fn, [p1, p2])
        [c1, c2 | acc]
      end
    )
  end

  @doc """
  Step 5 - Mutation to prevent premature convergence

  Follows the following rules:
    * Rule 14 - accepts a population as input
    * Rule 15 - mutates a small percentage of population
  """
  def mutation(population, opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      if :rand.uniform() < 0.05 do
        %Chromosome{chromosome | genes: Enum.shuffle(chromosome.genes)}
      else
        chromosome
      end
    end)
  end
end
