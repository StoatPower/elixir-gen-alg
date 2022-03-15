## For the One-Max problem, you're looking for the maximum sum of
## a bitstring of length N.

## Step 1 - Define the genotype
## Length of 1000 for consistency
genotype = fn -> for _ <- 1..1000, do: Enum.random(0..1) end

## Step 2 - Define the fitness function
## Fitness is just the sum
fitness_function = fn chromosome -> Enum.sum(chromosome) end

## Step 3 - Define termination criteria
## What's the max possible sum of a bitstring of length 1000? 1000
max_fitness = 1000

## Step 4 - Run the algorithm
solution = Genetic.run(fitness_function, genotype, max_fitness)

IO.write("\n")
IO.inspect(solution)
