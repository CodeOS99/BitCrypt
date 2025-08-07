extends Node2D

@onready var shop = $CanvasLayer

func _on_interact_help_shower_player_interact() -> void:
	get_tree().paused = true
	$CanvasLayer.visible = true
	AudioPlayer.play_shop_music()
