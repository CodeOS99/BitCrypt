extends Camera2D

var shake_amount: float = 0.0
var shake_decay: float = 5.0
var shake_strength: float = 5.0

var original_position: Vector2

func _ready():
	original_position = offset  # Save the starting offset

func _process(delta):
	if shake_amount > 0:
		shake_amount = max(shake_amount - shake_decay * delta, 0)
		var shake_offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * shake_amount * shake_strength
		offset = original_position + shake_offset
	else:
		offset = original_position

func start_shake(amount: float = 1.0, strength: float = 5.0, decay: float = 5.0):
	shake_amount = amount
	shake_strength = strength
	shake_decay = decay
