extends CharacterBody2D

const WALK_SPEED: float = 100.0
const RUN_SPEED: float = 200.0

var current_speed: float = WALK_SPEED
var can_move: bool = true

@onready var child_parent: Node2D = $childParent
@onready var animated_sprite: AnimatedSprite2D = $childParent/AnimatedSprite2D

func _physics_process(delta: float) -> void:
	handleMovement(delta)

func handleMovement(delta: float):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		if input_vector.x > 0:
			child_parent.scale.x = abs(child_parent.scale.x)
		elif input_vector.x < 0:
			child_parent.scale.x = -abs(child_parent.scale.x)
		velocity = current_speed * input_vector
		animated_sprite.play("walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, WALK_SPEED)
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

	move_and_slide()
