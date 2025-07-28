extends Node2D

@export_multiline var text_on_label: String = ""

@onready var tutorial_label = $Label
@onready var label_container = $CanvasLayer/PanelContainer

var is_player_in: bool = false

func _ready() -> void:
	label_container.get_child(0).text = text_on_label

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use"):
		label_container.visible = not label_container.visible
		tutorial_label.visible = false
	if not is_player_in:
		label_container.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		tutorial_label.visible = true
		is_player_in = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'player':
		tutorial_label.visible = false
		is_player_in = false
