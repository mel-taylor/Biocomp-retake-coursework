extends Node

var fitness

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func test(var genes):
	if(global.fitnessScript == 1):
		return(test_1(genes))
	elif(global.fitnessScript == 2):
		return(test_2(genes))
	elif(global.fitnessScript == 3):
		return(test_3(genes))

func bin_to_dec(binput): #converts binary to decimal
	var total = 0
	var count = 0
	for bit in binput: 
		total = total + (bit * pow(2, count))
		count = count + 1
	return total

func array_segment(inputArray, start, end): #copies part of an existing array
	var outputArray = []
	for i in range(start, end):
		outputArray.append(inputArray[i])
	return outputArray

func test_1(var genes):
	return pow(bin_to_dec(genes), 2)

func test_2(var genes):
	var y
	var x
	var fitness
	var xSign = genes[0]
	var xArray = array_segment(genes, 1, 4)
	var ySign = genes[0]
	var yArray = array_segment(genes, 6, 9)
	if xSign == 0:
		x = bin_to_dec(xArray)
	else:
		x = 0 - bin_to_dec(xArray)
	if ySign == 0:
		y = bin_to_dec(yArray)
	else:
		y = 0 - bin_to_dec(yArray)
	fitness = 0.26 * (pow(x, 2) + pow(y, 2)) - (0.48 * x * y)
	return fitness

func test_3(var genes):
	var x
	var n
	var divisor = 1/pow(2,23)
	var fitness = 0
	if genes[0] == 0:
		n = 10
	else:
		n = 20
	x = bin_to_dec(array_segment(genes, 1, 23))
	x = -5.12 + (x * divisor)
	for i in range (1, n):
		fitness = fitness + pow(x, 2) - 10*cos(2*PI*x)
	return fitness