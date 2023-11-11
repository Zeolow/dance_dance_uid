extends Button
class_name ButtonPlus

@onready var focus_sound: AudioStream
@onready var select_sound: AudioStream

@export var focus_on_visibility: bool = false


func _on_focus_entered():
	$Focus.play()


func _on_pressed():
	$Select.play()


func _on_visibility_changed():
	if visible and focus_on_visibility:
		grab_focus()
		
