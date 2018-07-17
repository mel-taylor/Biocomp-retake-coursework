extends Node2D

const GAscript = preload("GA.gd")
var genetic_algorithm

func _ready():
	pass

func _on_Popbox_text_entered( text ):
	global.p = int(text)

func _on_Tourbox_text_entered( text ):
	global.t = int(text)

func _on_Genebox_text_entered( text ):
	global.g = int(text)

func _on_Fitnessbox_text_entered( text ):
	global.fitnessScript = int(text)

func _on_Mutatebox_text_entered( text ):
	global.mutateRate = float(text)

func _on_Reversefitness_toggled( pressed ):
	global.reverseFitness = pressed

func _on_Crossover_toggled( pressed ):
	global.uniformCrossover = pressed

func _on_Start_pressed():
	remove_child(genetic_algorithm)
	genetic_algorithm = GAscript.new()
	add_child(genetic_algorithm)
	genetic_algorithm.init()
	print("done!")

func _on_Crossratebox_text_entered( text ):
	pass # replace with function body

func _on_Pause_pressed():
	genetic_algorithm.set_process(false)

func _on_Resume_pressed():
	genetic_algorithm.set_process(true)


func _on_SingleIteration_pressed():
	genetic_algorithm.evo_cycle()
