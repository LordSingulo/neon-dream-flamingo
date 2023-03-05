extends Node2D

onready var parallaxBackground: ParallaxBackground = $BackgroundCanvas/ParallaxBackground
onready var game_over_animation_player: AnimationPlayer = $GameOverAnimationPlayer
onready var player = $Player
onready var music_player = $MusicPlayer
onready var reset_button: Button = $GameOverCanvas/GameOverContainer/RetryButton
onready var obstacle_spawn_timer: Timer = $ObstacleSpawnTimer

export(Array, AudioStreamMP3) var songs
export(Array, Resource) var obstacles
export(Resource) var billboard

var spawned_obstacle_count = 0
var spawned_obstacles: Array

var game_over = false
var playlist: Array
var song_index = 0

func _ready():
	var _error = Globals.connect("game_ended", self, "on_game_ended")
	_error = Globals.connect("done_waiting", self, "on_done_waiting")
	_error = Globals.connect("game_reset", self, "on_game_reset")
	game_over_animation_player.play("RESET")
	
	playlist = songs
	playlist.shuffle()
	
	music_player.stream = songs[song_index]
	music_player.play()

func _process(delta):
	if not game_over:
		parallaxBackground.scroll_base_offset -= Vector2.RIGHT * 100 * delta
		music_player.pitch_scale = clamp(music_player.pitch_scale + delta, 0.5, 1)
	else:
		music_player.pitch_scale = clamp(music_player.pitch_scale - delta, 0.5, 1)

func on_game_ended():
	game_over = true
	game_over_animation_player.play("slide_text")
	reset_button.grab_focus()
	
func on_done_waiting():
	spawn_obstacle()

func spawn_obstacle():
	if not game_over:
		var new_obstacle
		if spawned_obstacle_count % 6 != 0 or spawned_obstacle_count == 0:
			new_obstacle = obstacles[randf() * obstacles.size()].instance()
		else:
			new_obstacle = billboard.instance()
		
		new_obstacle.position.x = ProjectSettings.get("display/window/size/width")
		get_tree().current_scene.add_child(new_obstacle)
		spawned_obstacles.append(new_obstacle)
		obstacle_spawn_timer.start(randf() + 2.0)
		spawned_obstacle_count += 1

func on_game_reset():
	game_over = false
	spawned_obstacle_count = 0
	for obstacle in spawned_obstacles:
		obstacle.queue_free()
	spawned_obstacles.clear()
	player.position = Vector2(240, 270)
	game_over_animation_player.play("RESET")
	reset_button.release_focus()
	obstacle_spawn_timer.stop()

func _on_RetryButton_pressed():
	Globals.emit_signal("game_reset")

func _on_MusicPlayer_finished():
	song_index += 1
	if song_index >= playlist.size():
		song_index = 0
	music_player.stream = playlist[song_index]
	music_player.play()
