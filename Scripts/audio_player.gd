extends Node

var curr_bg_player: AudioStreamPlayer2D

func playtitle_screen_music():
	if $title_screen_music.playing == false:
		$title_screen_music.play()
		curr_bg_player = $title_screen_music

func play_game_music():
	curr_bg_player.stop()
	$game_music.play()
	curr_bg_player = $game_music
