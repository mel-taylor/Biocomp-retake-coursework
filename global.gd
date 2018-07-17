extends Node

var p = 100 #population size
var t = 2 #tournament size
var g = 24 #genome size
var mutateRate = 0.25 #mutation rate
var crossoverRate = 0 #crossover rate
var fitnessScript = 3
var generationScript = "generation.gd"
var reverseFitness = false

var bestIndv #best individual produced, out of all GAs run