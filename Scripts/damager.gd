extends Area2D

signal hit(n: Node2D)

@export var damage: int
@export var parent_body: Node2D
@export var kb: int = 150
@export var self_kb: int = 0

var active: bool = true

func _ready() -> void:
	if damage == 0:
		print("damage 0")
	if parent_body == null:
		print("parent null")

func _process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if (("enemy" in body.name and not "enemy" in parent_body.name) or (body.name == "player" and parent_body.name != "player")) and body != parent_body and active:
			body.take_damage(damage + ((parent_body.name == "player") as int) * Globals.damage, kb, parent_body.global_position)
			parent_body.take_kb(self_kb, body.global_position)
			hit.emit(body)

func _on_body_entered(body: Node2D) -> void:
	if (("enemy" in body.name and not "enemy" in parent_body.name) or (body.name == "player" and parent_body.name != "player")) and body != parent_body and active:
		body.take_damage(damage + ((parent_body.name == "player") as int) * Globals.damage, kb, parent_body.global_position)
		parent_body.take_kb(self_kb, body.global_position)
		hit.emit(body)
