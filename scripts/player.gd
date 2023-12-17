extends KinematicBody2D

onready var collider: CollisionShape2D = $CollisionShape2D
onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer 
onready var sprite: AnimatedSprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var feathers: Particles2D = $Particles2D

export(Array, AudioStreamSample) var footsteps
export var flap_sound: AudioStreamSample = preload("res://audio/flap.wav")
export var collision_sound: AudioStreamSample = preload("res://audio/collision.wav")

export var gravity = 20.0
export var jump_strength = 10.0

var vertical_speed = 0.0
var waiting = true
var footstep_index = 0

func _ready():
	var _error = Globals.connect("game_ended", self, "_on_game_ended")
	_error = Globals.connect("done_waiting", self, "_on_done_waiting")
	_error = Globals.connect("game_reset", self, "_on_game_reset")
	sprite.play("bop")

func _physics_process(delta):
	# Add gravity
	if !waiting:
		vertical_speed -= gravity * delta
	else:
		vertical_speed = 0
	
	#Run on surfaces
	if raycast.is_colliding():
		collider.shape.extents = Vector2(32, 12)
		collider.position.y = -12
		sprite.position.y = -32
		if sprite.animation != "run":
			sprite.play("run")
	else:
		collider.shape.extents = Vector2(32, 6)
		collider.position.y = -6
		sprite.position.y = -7
		if sprite.animation == "run":
			sprite.play("bop")
	
	# Don't accelerate if landed
	var collision = move_and_collide(vertical_speed * Vector2.UP, false)
	if collision:
		vertical_speed = -gravity * delta
		Globals.landed = true
		if not audio_player.playing and collision.normal.y < 0:
			audio_player.stream = footsteps[0]
			audio_player.play()
	else:
		Globals.landed = false
		if audio_player.playing and not (Globals.landed or audio_player.stream == flap_sound):
			audio_player.stop()
	
	# End the game if player goes off screen
	if position.y - collider.shape.extents.y > ProjectSettings.get("display/window/size/height"):
		Globals.emit_signal("game_ended")
		sprite.visible = false

func _input(event):
	if event.is_action_pressed("action_jump"):
		vertical_speed += jump_strength
		sprite.frame = 0
		sprite.play("flap")
		audio_player.stream = flap_sound
		audio_player.play()
		if Globals.is_connected("done_waiting", self, "_on_done_waiting"):
			Globals.emit_signal("done_waiting")
			Globals.disconnect("done_waiting", self, "_on_done_waiting")

func _on_game_ended():
	raycast.enabled = false
	collision_layer = 0
	sprite.play("collision")
	audio_player.stream = collision_sound
	audio_player.play()
	feathers.restart()
	set_physics_process(false)
	set_process_input(false)

func _on_done_waiting():
	waiting = false

func _on_game_reset():
	raycast.enabled = true
	collision_layer = 1
	feathers.restart()
	feathers.emitting = false
	waiting = true
	Globals.landed = false
	set_physics_process(true)
	set_process_input(true)
	vertical_speed = 0
	var _error = Globals.connect("done_waiting", self, "_on_done_waiting")
	sprite.play("bop")
	sprite.position.x = 0
	sprite.visible = true

func _on_GroundCheck_body_entered(_body):
	collider.shape.extents = Vector2(32, 32)
	collider.position.y = 0
	sprite.play("run")

func _on_GroundCheck_body_exited(_body):
	collider.shape.extents = Vector2(32, 12)
	collider.position.y = -3.5
	sprite.play("flap")

func _on_AudioStreamPlayer2D_finished():
	if Globals.landed and raycast.enabled:
		footstep_index += 1
		if footstep_index >= footsteps.size():
			footstep_index = 0
		audio_player.stream = footsteps[footstep_index]
		audio_player.play()
