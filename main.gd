extends Node3D

@export_file("*.tscn") var game_scene_path
@export_file("*.tscn") var main_menu_scene_path
@export var songs: Array[Song] 

var selected_song: Song
var current_scene_node_path
var player_amount: int

@onready var player_select = $Main

func _ready():
	Globals.set_songs(songs)
	main_menu()

func main_menu() -> void:
	remove_current_scene()
	var main_menu_scene_resource = load(main_menu_scene_path)
	var main_menu_scene = main_menu_scene_resource.instantiate()
	
	add_child(main_menu_scene)
	current_scene_node_path = "MainMenu"
	main_menu_scene.load_songs(Globals.get_songs())
	main_menu_scene.song_selected.connect(_on_main_menu_song_selected)


func start_game() -> void:
	remove_current_scene()
	var game_scene_resource = load(game_scene_path)
	var game_scene = game_scene_resource.instantiate()
	add_child(game_scene)
	current_scene_node_path = "Game"

func remove_current_scene() -> void:
	if current_scene_node_path != null:
		var current_scene = get_node(current_scene_node_path)
		remove_child(current_scene)
		current_scene.call_deferred("free")


func _on_main_menu_song_selected():
	print("starting game")
	start_game()

