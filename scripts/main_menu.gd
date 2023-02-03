extends Node2D

func _on_StartButton_pressed():
	var _error = get_tree().change_scene(Constants.GAME_SCENE_PATH)

func _on_EditorButton_pressed():
	var _error = get_tree().change_scene(Constants.EDTOR_PATH)
