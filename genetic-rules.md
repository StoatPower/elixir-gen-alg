# Genetic Algorithms in a Nutshell

### How does a genetic algorithm work?

Genetic algorithms work via a series of `transformations` on `populations` of `chromosomes` over some number of `generations`. One generation represents one complete series of transformations. Ideally, the population that results from the subsequent generations have better solutions than previous ones. 

Every step in the process takes a population and produces a population for the next step.

#### What is a chromosome?

Chromosomes represent solutions to problems. Some problems are encoded using real values, some as permutations, and some using characters. The data structure is often a list, but sometimes the problem requires a different one to encode solutions. Specific encoding schemes vary from problem to problem.

#### What is a population?

A population is simply a collection of chromosomes. Usually, how you encode a population won't change--as long as the population is a series of chromosomes, it doesn't matter what data structure you use.

The size of a population doesn't matter either. Bigger populations take longer to `transform`, but they may `converge` on a solution faster, whereas smaller populations are easier to transform, but they may take longer to converge.

#### Rule 1

* Encode chromosomes using a data structure that supports collections.

#### Rule 2

* Your algorithm should work on any population size.

### Step 1 - Initializing the Population

The first step in every genetic algorithm is initializing the population, which is typically random. This is done with a `genotype` function, which is just a way to represent solutions.

#### Rule 3

* The initialization step must produce an initial population--a list of possible solutions.

#### Rule 4

* The function which initializes the population should be agnostic to how the chromosome is encoded. You can achieve this by accepting a function that returns a chromosome.

### Step 2 - Evaluating the Population

The evaluation step is responsible for evaluating each chromosome based on some `fitness function` and `sorting` the population based on this fitness. The fitness function is a way to measure success.

#### Rule 5

* The evaluation step must take a population as input.

#### Rule 6

* The evaluation step must produce a population sorted by fitness.

#### Rule 7

* The function which evaluates the population should take a parameter that is a function that returns the fitness of each chromosome.

#### Rule 8
 
* The fitness function can return anything, as long as the fitness can be sorted.

### Step 3 - Selecting Parents

Once sorted, you can begin selecting parents for reproduction. Selection is responsible for matching parents that will provide strong children. An initial selection method is simply pairing adjascent chromosomes. Later, different sorting mechanisms will be used.

#### Rule 9

* The selection step must take a population as input.

#### Rule 10

* The selection step must produce a transformed population that's easy to work with during crossover--say by returning a list of tuples which are pairs of parents.

### Step 4 - Creating Children

Crossover is analagous to reproduction. The goal of crossover is to exploit the strengths of current solutions to find new, better solutions.

#### Rule 11

* The crossover step should take a list of 2-tuples (or parents) as input.

#### Rule 12

* Combine the 2-tuples, representing pairs of parents using a crossover technique. For now, use single-point crossover.

#### Rule 13

* Return a population identical in size to the initial population.

### Step 5 - Creating Mutants

The goal of mutation is to prevent premature convergence by transforming some of the chromosomes in the population. The mutation rate sould be kept relatively low--typically somewhere around 5%.

#### Rule 14

* The mutation step should accept a population as input.

#### Rule 15

* The mutation step should mutate _only some_ of the chromosomes in the population--the percentage should be relatively small.

#### Rule 16

* The mutation strategy should be identical to the mutation function from previous chapter. (See `scripts/one_max.exs`)

### Step 6 - Termination Criteria

Termination criteria vary from problem to problem, but you absolutely must have some kind of termination criteria.

#### Rule 17

* Termination criteria must be defined by the problem--the framework must accept some problem-defined criteria to stop the algorithm.

#### Rule 18

* Termination critera, for now, must be just an integer--the maximum value needed to stop evolution.
