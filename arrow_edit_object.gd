extends HBoxContainer
class_name ArrowEditObject

@export var focus_color: Color
@export var unfocus_color: Color

var toggled = [false,false,false,false]

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
	toggled = [$Left.button_pressed,$Down.button_pressed, $Up.button_pressed,$Right.button_pressed]

func toggle_from_data(toggle_array: Array[bool]):
	$Left.button_pressed = toggle_array[0]
	$Down.button_pressed = toggle_array[1]
	$Up.button_pressed = toggle_array[2]
	$Right.button_pressed = toggle_array[3]
	print(toggle_array)
