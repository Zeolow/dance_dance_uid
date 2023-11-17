extends Control

var song_button_scene: Resource = preload("res://song_button.tscn")

@onready var song_button_parent: VBoxContainer = $SongSelect/Songs
@onready var playerSelect = $PlayerSelect
@onready var songSelect = $SongSelect
@onready var main = $Main

var songs_loaded: bool = false

var current_menu: String = "Main"

signal song_selected()

func _ready():
	playerSelect.visible = false
	songSelect.visible = false
	main.visible = true
	$Main/StartMenu/Start.grab_focus()
	

func _on_one_player_pressed():
	Globals.set_player_amount(1)
	player_selected()
	print("player selected")

func _on_two_player_pressed():
	Globals.set_player_amount(2)
	print("player_selected")
	player_selected()


func player_selected():
	show_menu("SongSelect")
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
	print(song_button)
	
func show_menu(node_path: String):
	$Main.visible = false
	$PlayerSelect.visible = false
	$SongSelect.visible = false
	if node_path == "Main":
		$Back.visible = false
	else:
		$Back.visible = true
	current_menu = node_path
	get_node(node_path).visible = true

func _on_song_selected():
	emit_signal("song_selected")


func _on_start_pressed():
	show_menu("PlayerSelect")
	$PlayerSelect/VBoxContainer/OnePlayer.grab_focus()


func _on_quit_pressed():
	get_tree().quit()


func _on_back_pressed():
	var menu_to_show: String
	match current_menu:
		"Main":
			menu_to_show = "Main"
		"PlayerSelect":
			menu_to_show = "Main"
		"SongSelect":
			menu_to_show = "PlayerSelect"
	show_menu(menu_to_show)
