extends Label

export(Array, String) var messages

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	text = messages[randi() % messages.size()]
