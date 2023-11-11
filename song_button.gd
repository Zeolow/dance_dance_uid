extends Button

signal song_selected()
var song_ref: Song

func song_select():
	Globals.set_song(song_ref)
	emit_signal("song_selected")

func _on_focus_entered():
	$Focus.play()

func _on_pressed():
	print("song button pressed")
	song_select()
	$Select.play()
