extends Control

var song_button_scene: Resource = preload("res://song_button.tscn")

@onready var song_button_parent: VBoxContainer = $SongSelect/Songs
@onready var playerSelect = $PlayerSelect
@onready var songSelect = $SongSelect
@onready var main = $Main
var songs_loaded: bool = false

signal song_selected()

func _ready():
	playerSelect.visible = false
	songSelect.visible = false
	main.visible = true
	$Main/Start.grab_focus()
	

func _on_one_player_pressed():
	Globals.set_player_amount(1)
	player_selected()
	print("player selected")

func _on_two_player_pressed():
	Globals.set_player_amount(2)
	player_selected()


func player_selected():
	playerSelect.visible = false
	songSelect.visible = true
	$SongSelect/Songs.get_child(0).grab_focus()

func load_songs(songs: Array[Song]):
	for song in songs:
		create_song_button(song)
	print("songs loaded")
	songs_loaded = true

func create_song_button(s: Song)-> void:
	var song_button = song_button_scene.instantiate()
	song_button.text = s.song_name
	song_button.song_ref = s
	song_button.song_selected.connect(_on_song_selected)
	song_button_parent.add_child(song_button)
	print("button created")
	print(song_button)
	

func _on_song_selected():
	print("song selected")
	emit_signal("song_selected")


func _on_start_pressed():
	main.visible = false
	playerSelect.visible = true
	$PlayerSelect/OnePlayer.grab_focus()
