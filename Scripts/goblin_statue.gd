extends Node2D

func _on_player_detector_player_enter() -> void:
	$AnimatedSprite2D.play("active")
	position.y -= 16
	$player_detector.queue_free() # its of no use now
