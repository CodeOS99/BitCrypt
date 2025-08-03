extends RigidBody2D

@export var speed: float = 1000.0
@export var stick_on_hit: bool = true

var facing_dir: String
var direction: Vector2
var can_hit_player

func _ready():
	if facing_dir == "up":
		direction = Vector2.UP
	elif facing_dir == "left":
		direction = Vector2.LEFT
	elif facing_dir == "down":
		direction = Vector2.DOWN
	else:
		direction =  Vector2.RIGHT
	rotation = direction.angle()
	linear_velocity = direction.normalized() * speed

func _on_damager_hit(body: Node2D) -> void:
	if stick_on_hit:
		linear_velocity = Vector2.ZERO
		get_parent().remove_child(self)
		body.add_child(self)
		global_position = to_local(body.global_position)
