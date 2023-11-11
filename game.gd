extends Node3D

@export_file("*.tscn") var player_scene_path

@onready var pauseScreen: Control = $PauseScreen
@onready var winScreen: Control =$WinScreen
@onready var winScreenLabel: Label = $WinScreen/VBoxContainer/Label
@onready var winScreenScore: Label = $WinScreen/VBoxContainer/Score
@onready var countDown: Control = $CountDown
@onready var countDownLabel: Label = $CountDown/Label
@onready var countDownTimer: Timer = $CountDown/Timer
@onready var countDownAudio: AudioStreamPlayer = $CountDown/AudioStream

var players: Array[Node2D]
var song_file: AudioStream

var paused: bool = false
var song_started: bool = false
var music_time_begin
var music_time_delay
var song_playing = false
var prev_time: float
var delta_time
var player_amount: int
var time: float
var pause_time: float
var latest_time_of_pause: float
var music_position


func _ready():
	for p in range(Globals.player_amount):
		print("spawning Player!")
		players.append(spawn_player(p + 1))
	countDown.visible = false
	winScreen.visible = false
	start_countdown()
	print("game ready!")


func _process(delta):
	if !song_started:
		countDownLabel.text = str(floor(countDownTimer.get_time_left()))
		if countDownTimer.get_time_left() <= 1.0:
			countDownLabel.text = "GO!"
	if song_started:
		# Obtain from ticks.
		time = (Time.get_ticks_usec() - music_time_begin) / 1000000.0 
		# Compensate for latency.
		time -= music_time_delay
		# May be below 0 (did not begin yet).
		time = max(0, time)
		var elapsed_time = time - pause_time
		if !paused:
			for p in players:
				p.move_arrows(elapsed_time)
			
		if Input.is_action_just_pressed("pause"):
			if paused:
				play()
			else:
				pause()

func start_countdown():
	countDown.visible = true
	countDownTimer.start()
	countDownAudio.play()

func spawn_player(player_nr: int) -> Player:
	var player_scene = load(player_scene_path)
	var player = player_scene.instantiate()
	player.name = "Player"+str(player_nr)
	match player_nr:
		1:
			player.position = Vector2(40,40) # MAKE EXPORTS ⇩
			player.action_codes = ["left", "down", "up", "right"]
		2: 
			player.position = Vector2(1216, 40)
			player.action_codes = ["p2_left", "p2_down", "p2_up", "p2_right"]
	add_child(player)
	print(player)
	return player

func start_song():
	pause_time = 0
	prev_time = 0
	countDown.visible = false
	$Song.stream = Globals.get_song().song_file
	$Song.play()
	player_amount = Globals.get_player_amount()
	song_playing = true
	paused = false
	pauseScreen.visible = false
	song_started = true
	
	music_time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	music_time_begin = Time.get_ticks_usec()

func set_player_amount(v: int) -> void:
	player_amount = v

func pause():
	pauseScreen.visible = true
	paused = true
	latest_time_of_pause = time
	
	music_position = $Song.get_playback_position()
	$Song.stop()

func play():
	pauseScreen.visible = false
	$PauseScreen/VBoxContainer/Menu.grab_focus()
	paused = false
	pause_time += time - latest_time_of_pause
	print(time)
	print("pause time")
	print(pause_time)
	$Song.play(music_position)

func _on_count_down_timer_timeout():
	start_song()


func _on_restart_pressed():
	for p in players:
		print("reset for")
		print(p)
		p.reset_song()
	song_started = false
	pauseScreen.visible = false
	winScreen.visible = false
	start_countdown()

func _on_menu_pressed():
	get_parent().main_menu()


func _on_song_finished():
	winScreen.visible = true
	song_started = false
	var score = players[0].score
	if players.size() == 2:
		if players[0].score > players[1].score:
			winScreenLabel.text = "PLAYER 1 WON!"
		else:
			winScreenLabel.text = "PLAYER 2 WON!"
			score = players[1].score
	winScreenScore.text = "Score: " + str(score)
