extends Node

@export var test: int

var selected_song: Song
var songs: Array[Song]
var player_amount: int
var main_menu_scene_path = "res://main_menu.tscn"

func set_song(song: Song) -> void:
	selected_song = song
	print("song set!")
	print(song.song_name)

func get_song() -> Song:
	return selected_song

func set_songs(v: Array[Song]) -> void:
	songs = v

func get_songs() -> Array[Song]:
	return songs

func set_player_amount(v: int) -> void:
	player_amount = v

func get_player_amount() -> int:
	return player_amount
