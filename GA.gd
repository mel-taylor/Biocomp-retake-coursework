extends Node

var population = [] #current population
var iterations = 0 #current number of GA iterations
var fitnessScript #script that determines fitness
var generationScript #script that determines population generation
var avgFitness #average fitness, this generation
var fittestIndividual #fittest individual, this generation
var maxFitness #maximum overall fitness
var minFitness #minimum overall fitness
var maxBestFitness #maximum best fitness
var minBestFitness #minimum best fitness
var gaID #unique ID for genetic algorithm, created from start time and date

class individual:
	var fitness
	var genes = []
	
	#creates an individual from preexisting fitness & genes
	func create_copy(var oldFitness, var oldGenes):
		fitness = oldFitness
		genes = [] + oldGenes
	
	#custom sort function
	func order(var indv1, var indv2):
		if indv1.fitness > indv2.fitness:
			if global.reverseFitness:
				return false
			else:
				return true
		else:
			if global.reverseFitness:
				return true
			else:
				return false
	
	func mutate():
		randomize()
		var selectedGene = randi() % genes.size()
		if genes[selectedGene] == 1:
			genes[selectedGene] = 0
		else:
			genes[selectedGene] = 1

func _ready():
	pass

#used to initialize the GA & then run it
func init():
	gaID = OS.get_datetime()
	print(gaID)
	fitnessScript = load("fitness.gd")
	generationScript = load(global.generationScript)
	var generator = generationScript.new()
	get_node("/root/Main/GraphDrawer").gaStarted()
	for i in range(global.p):
		population.append(individual.new())
		population[i].genes = [] + generator.generate()
	calc_population_fitness(population)
	update_analytics()

#calculates the fitness for every member of the population
#returns the total fitness of the population
func calc_population_fitness(var pop):
	var totalFitness = 0
	for i in pop:
		calc_individual_fitness(i)
		totalFitness += i.fitness
		if fittestIndividual == null:
			fittestIndividual = individual.new()
			fittestIndividual.create_copy(i.fitness, i.genes)
		elif i.order(i, fittestIndividual):
			fittestIndividual.create_copy(i.fitness, i.genes)
	return totalFitness

func calc_individual_fitness(var indv):
	var fitness_test = fitnessScript.new()
	add_child(fitness_test)
	indv.fitness = fitness_test.test(indv.genes)
	#updates the minimum & maxmium fitnesses
	if maxFitness == null:
		maxFitness = indv.fitness
	elif indv.fitness > maxFitness:
		maxFitness = indv.fitness
	if minFitness == null:
		minFitness = indv.fitness
	elif indv.fitness < minFitness:
		minFitness = indv.fitness
	remove_child(fitness_test)

#prints the genes & fitness of the entire population to the console
#useful for debugging, godot absolutely hates it
func print_population(var pop):
	for i in pop:
		print("genes = ", i.genes, " fitness = ", i.fitness)

#tournament style selection
func tournament():
	var contestants = []
	for j in range(global.t):
		randomize()
		contestants.append(population[randi() % global.p])
	contestants.sort_custom(contestants[0], "order")
	return contestants[0]

#recombination function
func crossover():
	randomize()
	var child = individual.new()
	var parent1 = tournament()
	var parent2 = tournament()
	var crosspoint = randf()
	for i in range(parent2.genes.size()):
		if i < crosspoint:
			child.genes.append(parent1.genes[i])
		else:
			child.genes.append(parent2.genes[i])
	return child

func update_analytics():
	avgFitness = calc_population_fitness(population) / global.p
	if global.bestIndv == null:
		global.bestIndv = individual.new()
		global.bestIndv.create_copy(fittestIndividual.fitness, fittestIndividual.genes)
	elif fittestIndividual.order(fittestIndividual, global.bestIndv):
		global.bestIndv.create_copy(fittestIndividual.fitness, fittestIndividual.genes)
	if maxBestFitness == null:
		maxBestFitness = fittestIndividual.fitness
	elif maxBestFitness < fittestIndividual.fitness:
		maxBestFitness = fittestIndividual.fitness
	if minBestFitness == null:
		minBestFitness = fittestIndividual.fitness
	elif minBestFitness > fittestIndividual.fitness:
		minBestFitness = fittestIndividual.fitness
	if fittestIndividual.fitness < 133.863507:
		set_process(false)
	print("best individual is ", fittestIndividual.genes, " fitness ", fittestIndividual.fitness)
	get_node("/root/Main/GraphDrawer").update_data(maxBestFitness, minBestFitness, fittestIndividual.fitness)

func evo_cycle():
	var offspring = []
	fittestIndividual = null
	iterations += 1
	
	#main loop to create new offspring
	for i in range(global.p):
		offspring.append(individual.new()) #creates empty individual 
		#filled with genes & fitness after this code
		var current
		randomize()
		if randf() < global.crossoverRate:
			current = crossover()
		else:
			current = tournament()
		offspring[i].create_copy(current.fitness, [] + current.genes)
		if randf() < global.mutateRate:
			offspring[i].mutate()
	
	population.clear()
	population = [] + offspring
	update_analytics()
	if iterations == 300:
		set_process(false)

func _process(delta):
	evo_cycle()