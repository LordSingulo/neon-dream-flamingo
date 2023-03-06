extends CenterContainer

onready var score_label = $ScoreContainer/Label

export(bool) var show_best = false

func _ready():
	if show_best:
		var _error = Globals.connect("game_ended", self, "_on_game_ended")
		score_label.text = "x " + str(Globals.best_score)
	else:
		var _error = Globals.connect("game_reset", self, "_on_update_score")
		_error = Globals.connect("pickup_diamond", self, "_on_update_score")
		score_label.text = "x " + str(Globals.score)

func _on_update_score():
	score_label.text = "x " + str(Globals.score)

func _on_game_ended():
	score_label.text = "x " + str(Globals.best_score)
