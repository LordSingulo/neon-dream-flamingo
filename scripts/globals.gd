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

func _on_game_ended():
	game_over = true

func _on_game_reset():
	game_over = false
