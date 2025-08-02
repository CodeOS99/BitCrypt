extends Node2D

signal player_enter
signal player_exit
signal player_interact

@onready var tutorial_label = $Label
var player_in = false

func _process(delta: float) -> void:
	if player_in and Input.is_action_just_released("use"):
		player_interact.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		tutorial_label.visible = true
		player_enter.emit()
		player_in = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'player':
		tutorial_label.visible = false
		player_exit.emit()
		player_in = false
