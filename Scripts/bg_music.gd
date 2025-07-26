extends AudioStreamPlayer

const bg_music = preload("res://Assets/Audio/music/Curiosity.mp3")

func _play_music(music: AudioStream, volume: float = 0.0):
	if stream == bg_music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_bg_music():
	_play_music(bg_music)
