extends CharacterBody2D

var max_heatlh: int = 10
var health: int = 10

@onready var sprite: AnimatedSprite2D = $FlipParent/AnimatedSprite2D
@onready var bar: ProgressBar = $ProgressBar

func _ready() -> void:
	bar.max_value = max_heatlh
	bar.value = bar.max_value

func _physics_process(delta: float) -> void:
	if not is_instance_valid(Globals.player_body):
		return

	if sprite.animation == "fly":
		var target_pos = Globals.player_body.global_position
		global_position = lerp(global_position, target_pos, 0.03)

	# Flip to face the player
	if (Globals.player_body.global_position - self.global_position).x > 0:
		$FlipParent.scale.x = 1
	else:
		$FlipParent.scale.x = -1

func _on_player_detector_player_enter() -> void:
	sprite.play("attack")

func take_damage(n: int, kb, pbPos):
	health -= n
	if health > 0:
		sprite.play("hurt")
	else:
		sprite.play("death")
	bar.value = health

func take_kb(a, b):
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation not in ["fly", "death"]:
		sprite.play("fly")
	elif sprite.animation == "death":
		var t = get_tree().create_tween()
		t.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 1)
		t.tween_callback(self.queue_free)
