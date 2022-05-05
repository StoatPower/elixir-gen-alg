defmodule NQueens do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = Enum.shuffle(0..7)
    %Chromosome{genes: genes, size: 8}
  end

  @impl true
  def fitness_function(chromosome) do
    diag_clashes =
      for i <- 0..7, j <- 0..7 do
        if i != j do
          dx = abs(i - j)
          dy =
            abs(
              chromosome.genes
              |> Enum.at(i)
              |> Kernel.-(Enum.at(chromosome.genes, j))
            )
          if dx == dy do
            1
          else
            0
          end
        else
          0
        end
      end

    length(Enum.uniq(chromosome.genes)) - Enum.sum(diag_clashes)
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    Enum.max_by(population, &NQueens.fitness_function/1).fitness == 8
  end

  @impl true
  def repair_chromosome(chromosome) do
    genes = MapSet.new(chromosome.genes)
    new_genes = repair_helper(genes, 8)
    %Chromosome{chromosome | genes: new_genes}
  end

  defp repair_helper(genes, k) do
    if MapSet.size(genes) >= k do
      MapSet.to_list(genes)
    else
      num = :rand.uniform(8)
      repair_helper(MapSet.put(genes, num), k)
    end
  end
end

IO.puts("-----------------------------------")
IO.puts("\nNQueens using Order-one Crossover\n")

soln = Genetic3.run(NQueens, crossover_type: &Toolbox.Crossover.order_one/2)

IO.write("\n")
IO.inspect(soln)

IO.puts("\n-----------------------------------")
IO.puts("\nNQueens restricted to Single-point Crossover but including Chromosome Repairment\n")

soln2 = Genetic3.run(NQueens, repairment_fn: &NQueens.repair_chromosome/1)

IO.write("\n")
IO.inspect(soln2)

IO.puts("\n-----------------------------------")
