extends "res://Scripts/Shop/shop_contaienr.gd"


func _on_back_btn_pressed() -> void:
	$"..".visible = false
	AudioPlayer.play_end_music()
	get_tree().paused = false
