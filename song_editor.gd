extends Control

@export var song: Song

var scroll_speed: float = 5.0
var arrow_container_prev_y: float = 0.0
var arrow_height: float= 72.0
var total_beats: float = 1.0
var arrow_edit_object_scene = preload("res://arrow_edit_object.tscn")
var focused_arrow_object: ArrowEditObject
var focused_index: int = 0
var song_length_sec: float
var song_time
var arrow_container_start_y: float

@onready var songControls: VBoxContainer = $SongControls
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer 
@onready var snapTimer: Timer = $SnapTimer
@onready var arrowContainer: VBoxContainer = $Control/ArrowContainer
@onready var focusPanel: Panel = $Control/FocusPanel


func _ready():
	audioStreamPlayer.stream = song.song_file
	audioStreamPlayer.play()
	
	var total_beats = calc_total_beats()
	var song_length_sec = song.song_file.get_length()
	arrow_container_start_y = arrowContainer.position.y
	
	var arrow_container_origin_y = arrowContainer.position.y
	for i in range(total_beats):
		#if song.arrows has beat toggle correct
		var arrow_object = arrow_edit_object_scene.instantiate()
		arrow_object.name = str(i)
		arrow_object.unfocus()
		arrowContainer.add_child(arrow_object)
	focused_arrow_object = arrowContainer.get_child(0)
	focused_arrow_object.focus()
	arrow_height = arrowContainer.get_child(0).size.y

func _process(delta):
	update_arrow_positions()
	arrow_container_prev_y = arrowContainer.position.y
	if Input.is_action_just_pressed("shift_down"):
		arrowContainer.position.y -= arrow_height
		focused_index += 1
		focused_arrow_object.unfocus()
		focused_arrow_object = arrowContainer.get_child(focused_index)
		focused_arrow_object.focus()
	if Input.is_action_just_pressed("shift_up"):
		arrowContainer.position.y += arrow_height
		focused_index -= 1
		focused_arrow_object.unfocus()
		focused_arrow_object = arrowContainer.get_child(focused_index)
		focused_arrow_object.focus()
		
	if not Input.is_key_pressed(KEY_SHIFT):
		if Input.is_action_just_pressed("left"):
			focused_arrow_object.toggle_button(0)
		if Input.is_action_just_pressed("down"):
			focused_arrow_object.toggle_button(1)
		if Input.is_action_just_pressed("up"):
			focused_arrow_object.toggle_button(2)
		if Input.is_action_just_pressed("right"):
			focused_arrow_object.toggle_button(3)
	
	update_display_data()

func update_arrow_positions() -> void:
	var t = audioStreamPlayer.get_playback_position()
	print("Time", t)
	var t_tot = song.song_file.get_length()
	var v = -1 * arrowContainer.size.y / t_tot
	print("V", v)
	var pos = v * t + arrow_container_start_y
	arrowContainer.position.y = pos
	print(pos)

func update_display_data() -> void:
	$SongControls/ElapsedTime/Time.text = str(audioStreamPlayer.get_playback_position())

func set_current_playback_time() -> void:
	pass

func get_current_playback_time() -> float:
	var time: float = audioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	return time

func calc_total_beats() -> int:
	var song_length = song.song_file.get_length()
	var bps = song.bpm / 60.0
	return int(song_length * bps)
	

	
func trackpad_logic(event):
	if event is InputEventPanGesture:
		arrowContainer.position.y -= event.delta.y * scroll_speed



