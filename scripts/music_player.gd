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
	
	# MP3s are assumed to be looped, can't be manually switched off in editor
	for song_info in playlist:
		song_info.song.loop = false
	
	play_song(song_index)

func play_song(index: int):
	player.stream = playlist[index].song
	player.play()
	now_playing_label.text = playlist[index].artist_name + " - " + playlist[index].song_name
	now_playing_animation_player.play("fade-out")

func _on_Player_finished():
	song_index += 1
	if song_index >= playlist.size():
		song_index = 0
	play_song(song_index)
