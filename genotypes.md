# Understanding and Choosing Genotypes

One of the most important decisions you can make when using a genetic algorithm is the type of _encoding_ you use to represent solutions. Encodings are simply representations of a single solution. A good encoding needs to contain only the information necessary to represent a complete solution to a problem.

The type of encoding scheme you use is known as a _genotype_. The genotype of a chromosome tells you what the chromosome should look like. It defines your search space.

While the genotype is the internal representation of solutions, the _phenotype_ is the expressed representation of solutions.

Common genotypes include:
    * binary
    * permutation
    * real-value
    * tree-based

#### Binary Genotypes

|1|1|0|0|1|1|0|

Binary genotypes, or _bitstrings_, are genes consisting of only 1s and 0s. This is the most common because you can apply it to such a wide variety of problems. For example, you can use binary genotypes in representing different characteristics. Each gene can represent the presence of a single characteristic--either with a 1 or a 0. They can even be used to represent continuous values.

#### Permutation Genotypes

|5|4|0|1|3|2|6|

Second most common. They are especially effective for scheduling problems or finding paths in a finite set of points. The types of problems involving permutation genotypes are called _combinatorial optimization_. These problems look for ordered solutions. One limitation of permutations is the type of mutation and crossover that you can use. It's especially difficult to create new chromosomes that maintain the integrity of the permutation. (Food for thought)

#### Real-Value Genotypes

|0.9|0.5|0.8|0.4|0.2|0.3|0.1|
|S|A|B|Q|T|Y|K|

These genotypes are represented using real values. This "real value" could be a string, a float, a character, and so forth. This is especially common for problems involving weights of some sort or where you need to generate a string. Real-value genotypes are less common, but they prove useful when you need to optimize parameters of some sort.

#### Tree/Graph Genotypes

            |+|
           /   \
        |-|     |X|
        / \     / \
     |1|  |7| |5|  |6|

One particularly interesting genotype is a tree-based or graph genotype. The most common application of tree genotypes is in _genetic programming_. Genetic programming is a branch of evolutionary computation in which one tries to evolve programs to achieve a desired result. The idea is that ou can teach a computer to program itself. Solutions are typically represented as syntax trees representing valid programs. As interesting as they are, there's little evidence that shows genetic programming is of any tangible use. It's difficult to evolve solutions so that they remain valid, and other techniques out there perform better on programming tasks.