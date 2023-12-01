extends Control

@export var song: Song

var scroll_speed: float = 5.0
var arrow_height: float= 72.0
var total_beats: float = 1.0
var arrow_edit_object_scene = preload("res://arrow_edit_object.tscn")
var focused_arrow_object: ArrowEditObject
var focused_index: int = 0
var song_length_sec: float
var song_time
var arrow_container_start_y: float
var playing = false
var current_song_position: float = 0.0

@onready var songControls: VBoxContainer = $SongControls
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer 
@onready var snapTimer: Timer = $SnapTimer
@onready var arrowContainer: VBoxContainer = $Control/ArrowContainer
@onready var focusPanel: Panel = $Control/FocusPanel


func _ready():
	audioStreamPlayer.stream = song.song_file
	
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
	if playing:
		update_arrow_positions()
		
	if not playing:
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
	if Input.is_action_just_pressed("space"):
		play_pause()
	
	update_display_data()

func update_arrow_positions() -> void:
	var t = audioStreamPlayer.get_playback_position()
	var t_tot = song.song_file.get_length()
	var v = -1 * arrowContainer.size.y / t_tot
	var pos = v * t + arrow_container_start_y
	var i = calc_current_arrow_index(pos)
	if i < arrowContainer.get_children().size():
		focused_arrow_object.unfocus()
		focused_index = i
		focused_arrow_object =  arrowContainer.get_child(focused_index)
		focused_arrow_object.focus()
		arrowContainer.position.y = -1 * arrow_height * focused_index + arrow_container_start_y 

func update_display_data() -> void:
	$SongControls/ElapsedTime/Time.text = str(audioStreamPlayer.get_playback_position())
	$SongControls/CurrentIndex/Index.text = str(focused_index)
	
func set_current_playback_time() -> void:
	pass

func get_current_playback_time() -> float:
	var time: float = audioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	return time

func calc_total_beats() -> int:
	var song_length = song.song_file.get_length()
	var bps = song.bpm / 60.0
	return int(song_length * bps)
	
func play_pause() -> void:
	if playing:
		current_song_position = get_current_playback_time()
		audioStreamPlayer.stop()
	elif not playing:
		print(current_song_position)
		var song_t = song.song_file.get_length()
		var play_pos = song_t/arrowContainer.get_child_count() * focused_index
		print("PLAY;", play_pos)
		audioStreamPlayer.play(play_pos)
	playing = !playing
	
	
func trackpad_logic(event):
	if event is InputEventPanGesture:
		arrowContainer.position.y -= event.delta.y * scroll_speed

func calc_current_arrow_index(pos: float) -> int:
	var index: int = -1*floor((pos+arrow_height/2.0) / arrow_height)
	return index

