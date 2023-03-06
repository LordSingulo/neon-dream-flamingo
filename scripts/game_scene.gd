extends Node2D

onready var parallaxBackground: ParallaxBackground = $BackgroundCanvas/ParallaxBackground
onready var game_over_animation_player: AnimationPlayer = $GameOverCanvas/GameOverAnimationPlayer
onready var player = $Player
onready var reset_button: Button = $GameOverCanvas/GameOverContainer/RetryButton
onready var obstacle_spawn_timer: Timer = $ObstacleSpawnTimer
onready var score_canvas: CanvasLayer = $ScoreCanvas
onready var music_player: CanvasLayer = $MusicPlayer

export(Array, Resource) var obstacles
export(Resource) var billboard

var spawned_obstacle_count = 0

func _ready():
	var _error = Globals.connect("game_ended", self, "_on_game_ended")
	_error = Globals.connect("done_waiting", self, "_on_done_waiting")
	_error = Globals.connect("game_reset", self, "_on_game_reset")
	_error = Globals.connect("pickup_diamond", self, "_on_diamond_picked_up")
	
	game_over_animation_player.play("RESET")

func _process(delta):
	if not Globals.game_over:
		parallaxBackground.scroll_base_offset -= Vector2.RIGHT * 100 * delta

func _on_game_ended():
	game_over_animation_player.play("slide_text")
	reset_button.grab_focus()
	
func _on_done_waiting():
	spawn_obstacle()

func spawn_obstacle():
	if not Globals.game_over:
		var new_obstacle
		if spawned_obstacle_count % 6 != 0 or spawned_obstacle_count == 0:
			new_obstacle = obstacles[randf() * obstacles.size()].instance()
		else:
			new_obstacle = billboard.instance()
		
		new_obstacle.position.x = ProjectSettings.get("display/window/size/width")
		get_tree().current_scene.add_child(new_obstacle)
		# Minimum 1 sec, max 3
		var wait_time = (randf() * 2.0) + 1.5
		obstacle_spawn_timer.start(wait_time)
		spawned_obstacle_count += 1

func _on_game_reset():
	spawned_obstacle_count = 0
	player.position = Vector2(240, 270)
	game_over_animation_player.play("RESET")
	reset_button.release_focus()
	obstacle_spawn_timer.stop()
	Globals.score = 0

func _on_RetryButton_pressed():
	Globals.emit_signal("game_reset")

func _on_diamond_picked_up():
	Globals.score += 1
	if Globals.score > Globals.best_score:
		Globals.best_score = Globals.score
