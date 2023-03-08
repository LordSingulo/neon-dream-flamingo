extends CanvasLayer

func _input(event):
	if event.is_action_pressed("action_jump"):
		queue_free()
