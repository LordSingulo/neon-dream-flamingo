extends Node

signal game_ended
signal paused
signal done_waiting
signal game_reset

func _ready():
	var _error = connect("game_ended", self, "on_signal_fired",["Game ended."])
	_error = connect("paused", self, "on_signal_fired",["Paused."])
	_error = connect("done_waiting", self, "on_signal_fired",["Done waiting."])
	_error = connect("game_reset", self, "on_signal_fired",["Game reset."])
	
	# This is just to get debugger to shut up about the signals being unused,
	# doesn't actually do anything since it will happen in main menu
	print("Initialize signals.")
	emit_signal("done_waiting")
	emit_signal("paused")
	emit_signal("game_ended")
	emit_signal("game_reset")

func on_signal_fired(message: String):
	print(message)
