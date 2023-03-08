extends KinematicBody2D
onready var sprite = $Sprite

export var move_speed = 4.0
export var goes_up_and_down = false
var game_ended = false

func _ready():
	var _error = Globals.connect("game_ended", self, "_on_game_ended")
	_error = Globals.connect("game_reset", self, "_on_game_reset")

func _process(_delta):
	if !game_ended:
		var collision = move_and_collide(Vector2.LEFT * move_speed)
		position.y = 348
		if collision:
			if not Globals.landed:
				Globals.emit_signal("game_ended")
		if sprite.texture:
			if position.x <= 0 - sprite.get_rect().size.x:
				queue_free()
		else:
			if position.x <= 0 - 540:
				queue_free()

func _on_game_ended():
	game_ended = true

func _on_game_reset():
	queue_free()
