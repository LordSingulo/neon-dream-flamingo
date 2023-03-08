extends Camera2D

var shake_camera = false
var original_offset = offset_h

func _ready():
	var _error = Globals.connect("game_ended", self, "on_shake_camera")

func on_shake_camera():
	shake_camera = true
	yield(get_tree().create_timer(0.2), "timeout")
	shake_camera = false
	offset_h = original_offset

func _process(_delta):
	if shake_camera:
		offset_h = original_offset + randf() * 0.25
