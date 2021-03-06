defmodule Genetic do
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

    best = Enum.max_by(population, &problem.fitness_function/1)
    best_fitness = best.fitness
    temperature = 0.8 * (temperature + (best_fitness - last_max_fitness))
    IO.write("\rCurrent Best: #{best.fitness}")

    if problem.terminate?(population, generation, temperature) do
      best
    else
      generation = generation + 1

      population
      |> selection(opts)
      |> crossover(opts)
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

  Follows the following rules:
    * Rule 9 - takes a population as input
    * Rule 10 - produces a transformed population that easy's to work
        with during crossover
  """
  def selection(population, opts \\ []) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
  end

  @doc """
  Step 4 - Crossover: recombine selected parents into new children

  Follows the following rules:
    * Rule 11 - takes a list of parents as input
    * Rule 12 - recombines the list of parents using a crossover function
    * Rule 13 - returns a population of the same size as input population
  """
  def crossover(population, opts \\ []) do
    population
    |> Enum.reduce(
      [],
      fn {p1, p2}, acc ->
        cx_point = :rand.uniform(length(p1.genes))
        {{h1, t1}, {h2, t2}} = {Enum.split(p1.genes, cx_point), Enum.split(p2.genes, cx_point)}
        {c1, c2} = {%Chromosome{p1 | genes: h1 ++ t2}, %Chromosome{p2 | genes: h2 ++ t1}}
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
