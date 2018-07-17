extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func generate():
	var genes = []
	for i in range(global.g):
		randomize()
		genes.append(randi() % 2)
	return genes