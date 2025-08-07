extends Node

@export var beepSoundPlayer: AudioStreamPlayer2D
@export var selectSoundPlayer: AudioStreamPlayer2D

var curr_bg_player: AudioStreamPlayer2D

func playtitle_screen_music():
	if $title_screen_music.playing == false:
		$title_screen_music.play()
		curr_bg_player = $title_screen_music

func play_game_music():
	if $game_music.playing == false:
		curr_bg_player.stop()
		$game_music.play()
		curr_bg_player = $game_music

func play_shop_music():
	if $shop_music.playing == false:
		curr_bg_player.stop()
		$shop_music.play()
		curr_bg_player = $shop_music
