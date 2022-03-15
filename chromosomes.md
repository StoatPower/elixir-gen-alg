# Chromosome Guide

At the most basic level, a chromosome is a single solution to your problem. It's a series of genes consisting of values known as _alleles_.
Genes are typically represented using list types or other enumerable data types, like trees, sets, and arrays.

* Represent chromosomes with `structs`. 
* With structs, you can ensure that a predefined chromosome type is initialized with a predefined set of genes--one that won't break your genetic algorithms.
* Using a struct, you can save time by only calculating the fitness once, and then storing it as a key-value pair within the struct itself.
* Beyond it's genes, you can add any number of "meta" characteristics to a chromosome, like the calculated fitness score, for both convenience and functionality, like size and age.