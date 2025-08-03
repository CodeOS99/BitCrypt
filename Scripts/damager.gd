extends Area2D

signal hit(n: Node2D)

@export var damage: int

func _ready() -> void:
	if damage == 0:
		print("damage 0")

func _on_body_entered(body: Node2D) -> void:
	if "enemy" in body.name or body.name == "Player":
		body.take_damage(damage)
		hit.emit(body)
