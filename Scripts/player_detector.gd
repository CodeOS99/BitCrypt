extends Area2D

signal player_enter
signal player_exit

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_enter.emit()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_exit.emit()
