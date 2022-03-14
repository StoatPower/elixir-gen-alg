# Hah! I reached best fit of 1000 on first run without mutation! Lol.

# (Step 1) Initial population
population = for _ <- 1..100, do: for _ <- 1..1000, do: Enum.random(0..1)

# (Step 2) Evaluate population
# - evaluate each chromosome based on a fitness function
evaluate =
  fn population ->
    Enum.sort_by(population, &Enum.sum/1, &>=/2)
  end

# (Step 3) Select parents
# - select parents to be combined to create new solutions
# - goal is to pick parents that are easily combined to create better solutions
selection =
  fn population ->
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
  end

# (Step 4) Create children
# - take two or more parent chromosomes and produce two or more child chromosomes
# - want to produce a population you can pas back into the algorithm fn
crossover =
  fn population ->
    Enum.reduce(population, [],
      fn {p1, p2}, acc ->
        cx_point = :rand.uniform(1000)
        # single point crossover technique
        {{h1, t1}, {h2, t2}} =
          {Enum.split(p1, cx_point), Enum.split(p2, cx_point)}
        [h1 ++ t2, h2 ++ t1 | acc]
      end
    )
  end

# (Step 5) Mutate population
# - you only want to mutate a small percentage of population in order
# to preserve the progress that's already been made
mutation =
  fn population ->
    population
    |> Enum.map(
      fn chromosome ->
        if :rand.uniform() < 0.05 do
          Enum.shuffle(chromosome)
        else
          chromosome
        end
      end
    )
  end

# (Step 5) Repeat the process with new population
algorithm =
  fn population, algorithm ->
    # extract current best solution from the population
    best = Enum.max_by(population, &Enum.sum/1)
    # print value of largest sum
    IO.write("\rCurrent Best: " <> Integer.to_string(Enum.sum(best)))
    # if 1000 is reached, return best
    if Enum.sum(best) == 1000 do
      best
    else
      population
      |> evaluate.()
      |> selection.()
      |> crossover.()
      |> mutation.()
      |> algorithm.(algorithm)
    end
  end

  solution = algorithm.(population, algorithm)

  IO.write("\n Answer is \n")
  IO.inspect solution
