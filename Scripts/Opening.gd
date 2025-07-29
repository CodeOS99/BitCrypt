class_name Opening
extends Node2D

@export var door: Door
@onready var player_spawn_pos: Vector2 = door.global_position
@onready var coords: Vector2i = door.dir
