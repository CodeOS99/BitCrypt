extends Node2D

signal player_enter
signal player_exit

@onready var tutorial_label = $Label

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		tutorial_label.visible = true
		print("player in :D")
		player_enter.emit()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'player':
		tutorial_label.visible = false
		player_exit.emit()
