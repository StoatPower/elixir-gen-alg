defmodule Speller do
  @behaviour Problem
  alias Types.Chromosome

  @moduledoc """
  Speller is a genetic algorithm intended to solve the spelling of
  'supercalifragilisticexpialidocious', which i sa 34-letter word.
  Thus, our search space is all 34-letter words.

  For some reason, I can't get this to solve. Then again,
  he says it can take awhile to solve in this form. Maybe that's it,
  it just takes forever.
  """

  @impl true
  def genotype do
    genes =
      Stream.repeatedly(fn -> Enum.random(?a..?z) end)
      |> Enum.take(34)
    %Chromosome{genes: genes, size: 34}
  end

  @impl true
  def fitness_function(chromosome) do
    target = "supercalifragilisticexpialidocious"
    guess = List.to_string(chromosome.genes)
    String.jaro_distance(target, guess)
  end

  @impl true
  def terminate?([best | _]), do: best.fitness == 1
end

solution = Genetic.run(Speller)

IO.write("\n")
IO.inspect(solution)
