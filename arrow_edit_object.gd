extends HBoxContainer
class_name ArrowEditObject

@export var focus_color: Color
@export var unfocus_color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func focus():
	modulate = focus_color

func unfocus():
	modulate = unfocus_color

func toggle_button(index: int):
	match index:
		0:
			$Left.button_pressed = !$Left.button_pressed
		1:
			$Down.button_pressed = !$Down.button_pressed
		2:
			$Up.button_pressed = !$Up.button_pressed
		3:
			$Right.button_pressed = !$Right.button_pressed
