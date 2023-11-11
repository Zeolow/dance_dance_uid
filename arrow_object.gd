extends Node2D

var arrows: Array = [0,0,0,0] 
var toggled = [0, 0, 0, 0]

@onready var sprites = [$Left/Sprite2D, $Down/Sprite2D, $Up/Sprite2D, $Right/Sprite2D]


func _ready() -> void:
	for sprite in sprites:
		sprite.visible = false
		
	for i in range(arrows.size()):
		if arrows[i] == 1:
			sprites[i].visible = true
			toggled[i] = 1

func press_arrow(index: int):
	sprites[index].visible = false
	toggled[index] = 0

func reset(arrow_data: Array) -> void:
	toggled = arrow_data
	for i in range(arrow_data.size()):
		if arrow_data[i] == 1:
			sprites[i].visible = true
