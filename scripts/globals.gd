extends Node

signal game_ended
signal paused
signal done_waiting
signal game_reset
signal pickup_diamond

var score = 0
var best_score = 0
var landed = false
var game_over = false

func _ready():
	var _error = connect("game_ended", self, "_on_game_ended")
	_error = connect("game_reset", self, "_on_game_reset")
	
	# This is to stop console from saying signals aren't used. They are, just not in this file
	_error = connect("game_ended", self, "_on_signal_fired", ["game_ended connected."])
	_error = connect("paused", self, "_on_signal_fired", ["paused connected."])
	_error = connect("done_waiting", self, "_on_signal_fired", ["done_waiting connected."])
	_error = connect("game_reset", self, "_on_signal_fired", ["game_reset connected."])
	_error = connect("pickup_diamond", self, "_on_signal_fired", ["pickup_diamond connected."])
	
	emit_signal("game_ended")
	emit_signal("paused")
	emit_signal("done_waiting")
	emit_signal("game_reset")
	emit_signal("pickup_diamond")
	
func _on_signal_fired(text: String):
	print(text)

func _on_game_ended():
	game_over = true

func _on_game_reset():
	game_over = false
