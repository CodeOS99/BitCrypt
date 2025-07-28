class_name Opening
extends Node2D

@export var coords: Vector2i  # e.g. (1, 0), (-1, 0), (0, 1), etc.
@onready var player_spawn_pos: Vector2 = self.global_position

func _ready() -> void:
	print(player_spawn_pos)
