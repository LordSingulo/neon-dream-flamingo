extends CanvasLayer

onready var now_playing_animation_player: AnimationPlayer = $NowPlayingAnimationPlayer
onready var now_playing_label: Label = $NowPlayingLabel
onready var player = $Player

export(Array, Resource) var songs

var playlist: Array
var song_index = 0

func _process(delta):
	if not Globals.game_over:
		player.pitch_scale = clamp(player.pitch_scale + delta, 0.5, 1)
	else:
		player.pitch_scale = clamp(player.pitch_scale - delta, 0.5, 1)

func _ready():
	randomize()
	playlist = songs
	playlist.shuffle()
	
	# Workaround to get music synced with background
	yield(get_tree(), "idle_frame")
	play_song(song_index)

func _on_MusicPlayer_finished():
	song_index += 1
	if song_index >= playlist.size():
		song_index = 0
	play_song(song_index)

func play_song(index: int):
	player.stream = playlist[index].song
	player.play()
	now_playing_label.text = playlist[index].artist_name + " - " + playlist[index].song_name
	now_playing_animation_player.play("fade-out")
