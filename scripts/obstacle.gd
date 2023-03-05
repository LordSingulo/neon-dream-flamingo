extends KinematicBody2D

export var move_speed = 4.0
export var goes_up_and_down = false
signal past_obstacle

var game_ended = false

func _ready():
	var _error = Globals.connect("game_ended", self, "on_game_ended")

func _process(_delta):
	if !game_ended:
		var collision = move_and_collide(Vector2.LEFT * move_speed)
		position.y = 348
		if collision:
			Globals.emit_signal("game_ended")
		if position.x <= 0:
			emit_signal("past_obstacle")

func on_game_ended():
	game_ended = true
