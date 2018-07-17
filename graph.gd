extends Node2D

#top left corner of drawable space (static, based on prebuilt UI)
#lives here because constants can't be in functions
const topLeft = Vector2(100, 174)
var minFitness
var maxFitness
var maxIterations
#counts the number of times a GA has been run, starting at 0
var gaCounter
var topFitnesses = []

var defaultFont

func _ready():
	topFitnesses.append([])
	#fetches the godot default font, which you have to do like this fsr
	var label = Label.new()
	defaultFont = label.get_font("")
	label.free()

func _fixed_process(delta):
	update()

func create_unique_colour(var i):
	i = i % 8
	var red
	var green
	var blue
	if i % 2 != 0:
		red = 1
	else:
		red = 0
	i = i / 2
	if i % 2 != 0:
		green = 1
	else:
		green = 0
	i = i / 2
	blue = i
	return Color(red, green, blue)

func _draw():
	if is_fixed_processing():
		#bottom right corner of drawable space (dynamic, based on viewport)
		var bottomRight = get_viewport_rect().size - Vector2(40,40)
		draw_line(topLeft, Vector2(topLeft.x, bottomRight.y), Color(0,0,0))
		draw_line(Vector2(topLeft.x, bottomRight.y), bottomRight, Color(0,0,0))
		if(topFitnesses[0].size() >= 2):
			#calculates the distance (in pixels) between data points
			var xPointDist = (bottomRight.x - topLeft.x) / maxIterations
			var yPointDist = (topLeft.y - bottomRight.y) / (maxFitness - minFitness)
			var xInterval = get_interval(maxIterations)
			var yInterval = get_interval(maxFitness - minFitness)
			#displays highest/lowest values
			draw_string(defaultFont, topLeft - Vector2(80, 0), String(maxFitness), Color(0,0,0))
			draw_string(defaultFont, Vector2(topLeft.x - 80, bottomRight.y), String(minFitness), Color(0,0,0))
			draw_string(defaultFont, Vector2(topLeft.x, bottomRight.y + 20), "0", Color(0,0,0))
			draw_string(defaultFont, bottomRight + Vector2(0, 20), String(maxIterations), Color(0,0,0))
			#displays intermediate values
			#while(totalDist < maxIterations):
			#	totalDist
			#print(get_interval(maxFitness - minFitness))
			#print(get_interval(maxIterations))
			for i in range (topFitnesses.size()):
				var lineColour = create_unique_colour(i)
				for j in range(topFitnesses[i].size() - 2):
					#draws the top fitness line
					var point1 = Vector2(topLeft.x + xPointDist * j, bottomRight.y + yPointDist * (topFitnesses[i][j] - minFitness))
					var point2 = Vector2(topLeft.x + xPointDist * (j + 1), bottomRight.y + yPointDist * (topFitnesses[i][j + 1] - minFitness))
					draw_line(point1, point2, lineColour)

#call when GA has finished working, to update analytics
func update_data(localMax, localMin, localTop):
	topFitnesses[gaCounter].append(localTop)
	#updates the overall max & min if needs be
	if maxFitness == null:
		maxFitness = localMax
		minFitness = localMin
	elif localMax > maxFitness:
		maxFitness = localMax
	elif localMin < minFitness:
		minFitness = localMin
	
	if maxIterations == null:
		maxIterations = topFitnesses[gaCounter].size()
	elif topFitnesses[gaCounter].size() > maxIterations:
		maxIterations = topFitnesses[gaCounter].size()

func get_interval(var i):
	i = String(i)
	var interval = 10
	for i in range (i.length() - 2):
		interval *= 10
	return interval

func _on_DrawGraph_toggled( pressed ):
	if pressed:
		set_fixed_process(true)
		show()
	else:
		set_fixed_process(false)
		hide()

#counts the number of seperate GAs that have been run
func gaStarted():
	if gaCounter == null:
		gaCounter = 0
	else:
		gaCounter += 1
		topFitnesses.append([])