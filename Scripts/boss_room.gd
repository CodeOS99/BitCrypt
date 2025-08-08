extends Node2D

@export var player_spawn_pos: Vector2
@export var dramatic_bar_thickness = 40

func _ready() -> void:
	#Globals.player.camera.limit_top = -
	Globals.player.camera.limit_right = 592
	Globals.player.camera.limit_bottom = 432
	AudioPlayer.play_boss_bg_music()
