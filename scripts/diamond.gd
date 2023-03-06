extends Node2D

onready var pickup_sound = $AudioStreamPlayer
onready var sprite = $Sprite

func _on_Area2D_body_entered(_body):
	pickup_sound.play()
	sprite.visible = false
	Globals.emit_signal("pickup_diamond")

func _on_AudioStreamPlayer_finished():
	queue_free()
