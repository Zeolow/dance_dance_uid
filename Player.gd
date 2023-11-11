extends Node2D
class_name Player

@export var action_codes = ["left", "down", "up", "right"]

var song: Song

var arrow_speed: float
var spacing: float = 64
var arrow_size: float = 64.0 # make global variable
var arrow_object_scene = preload("res://arrow_object.tscn")
var distance_to_next_arrow: float
var current_arrow_index: int = 0
var arrow_objects: Array
var current_arrow_object: Node2D

var score: int = 0
var combo: int = 0
var multiplier: int = 1
var evaluations: Array = ["_______","_______","_______","_______"]

var paused: bool = false

@onready var arrow_parent_node: Node2D= $Arrows
@onready var arrow_home: Node2D = $ArrowHome

func reset_song():
	print("resetting song")
	print(song)
	current_arrow_index = 0
	current_arrow_object = arrow_parent_node.get_child(0)
	arrow_parent_node.position.y = calc_start_distance(0)
	arrow_speed = calc_speed()
	score = 0
	combo = 0
	multiplier = 1
	evaluations = ["_______","_______","_______","_______"]
	var i = 0
	for a in arrow_parent_node.get_children():
		a.reset(song.arrow_data[i].duplicate())
		i += 1
	update_debug_text()

func _ready() -> void:
	song = Globals.get_song()
	arrow_parent_node.position.y = calc_start_distance(0)
	arrow_speed = calc_speed()
	
	var i = 0
	for ar_obj in song.arrow_data:
		create_arrow_object(i, ar_obj, spacing)
		i += 1
	
	arrow_objects = arrow_parent_node.get_children()
	current_arrow_object = arrow_parent_node.get_child(0)

func move_arrows(time: float) -> void:
	arrow_parent_node.position.y = -(arrow_speed * time)
	distance_to_next_arrow = arrow_objects[current_arrow_index].global_position.y - position.y
	if abs(distance_to_next_arrow) <= 32:
		var i = 0
		for action in action_codes:
			if Input.is_action_just_pressed(action):
				if current_arrow_object.toggled[i]:
					print("pressing_arrow")
					current_arrow_object.press_arrow(i)
					score += calc_score(abs(distance_to_next_arrow), i)
					combo += 1
					multiplier = calc_multiplier(combo)
					
				else:
					combo = 0
			i+= 1
			
	if distance_to_next_arrow <= -32.0:
		#Checks if any are still on when passed
		for i in range(4):
				if current_arrow_object.toggled[i]:
					combo = 0
					evaluations[i] = "miss   "
		
		if current_arrow_index < arrow_objects.size() -1:
			current_arrow_index += 1
			current_arrow_object = arrow_parent_node.get_child(current_arrow_index)
			update_debug_text()
			#debug stuff
		
		else:
			arrow_speed = 0

func calc_speed() -> float: # px/s
	var arr_size: float = arrow_size + spacing
	var speed: float = song.bpm * arr_size/60.0
	return speed


func calc_start_distance(start_time: float) -> float:
	var speed: float = calc_speed()
	var start_distance = speed * start_time
	return start_distance


func create_arrow_object(index: int, arrows: Array, spacing: float) -> void:
	var arrow_object = arrow_object_scene.instantiate()
	arrow_object.name = str(index)
	arrow_object.position.y = index * (arrow_size+spacing)
	arrow_object.arrows = arrows
	arrow_parent_node.add_child(arrow_object)


func calc_score(dist: float, index: int) -> float:
	var s: int = 0.0
	if dist <= 10.0:
		evaluations[index] = "PERFECT"
		s = 10.0 * multiplier
	elif dist <= 32.0:
		evaluations[index] = "OK     "
		s = 1.0 * multiplier
	
	$Debug/Score/Score.text = str(score + s)
	return s

func calc_multiplier(combo: int) -> int:
	if combo >= 20:
		return 4
	if combo >= 10:
		return 2
	return 1

func update_debug_text() -> void:
	$Debug/Score/Score.text = str(score)
	$Debug/Index/Index.text = str(current_arrow_index)
	$Debug/CurrentArrowObj/ArrObjName.text = current_arrow_object.name
	$Debug/Toggled/Toggled.text = str(current_arrow_object.toggled)
	$Debug/Combo/Combo.text = str(combo)
	$Debug/Multiplier/Multiplier.text = str(multiplier)
	$Debug/Evaluation/E0.text = evaluations[0]
	$Debug/Evaluation/E1.text = evaluations[1]
	$Debug/Evaluation/E2.text = evaluations[2]
	$Debug/Evaluation/E3.text = evaluations[3]
