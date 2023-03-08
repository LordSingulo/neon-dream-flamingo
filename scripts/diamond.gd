extends Node2D

onready var pickup_sound: AudioStreamPlayer = $AudioStreamPlayer
onready var sprite: AnimatedSprite = $AnimatedSprite
onready var particles: Particles2D = $Particles2D
onready var timer: Timer = $Timer

func _on_Area2D_body_entered(_body):
	pickup_sound.play()
	sprite.visible = false
	Globals.emit_signal("pickup_diamond")
	particles.emitting = true
	timer.start(particles.lifetime)

func _on_Timer_timeout():
	queue_free()
