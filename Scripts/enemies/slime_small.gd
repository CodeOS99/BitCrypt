class_name SlimeBoss 
extends CharacterBody2D

@export var max_health: int = 10
@export var health: int = 10
@export var speed: int = 75
@export var value: int = 1 # increases the boss's tyrrany counter by this value
@export var knockback_decay: float = 150.0
@export var move_frame: Array[int] = [2]

var knockback_velocity: Vector2 = Vector2.ZERO
var move_velocity: Vector2 = Vector2.ZERO

var toPlaySound = true

func _ready() -> void:
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health

func _physics_process(delta: float) -> void:
	if not is_instance_valid(Globals.player_body):
		return
	move_velocity = Vector2.ZERO # reset

	if knockback_velocity.length() > 0.1: # kb
		move_velocity += knockback_velocity
		# damp
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	else:
		knockback_velocity = Vector2.ZERO

	if $FlipParent/AnimatedSprite2D.animation == "jump" and $FlipParent/AnimatedSprite2D.frame in move_frame:
		var dir_to_player = (Globals.player_body.global_position - global_position).normalized()
		move_velocity += dir_to_player * speed
		if toPlaySound:
			AudioPlayer.slimeJumpPlayer.play()
			toPlaySound = false
	else:
		toPlaySound = true

	velocity = move_velocity
	move_and_slide()

	if (Globals.player_body.global_position - global_position).x > 0:
		$FlipParent.scale.x = 1
	else:
		$FlipParent.scale.x = -1

func take_damage(n: int, kb: int, from_pos):
	if $FlipParent/AnimatedSprite2D.animation in ["hurt", "death"]:
		return
	
	health -= n
	$ProgressBar.value = health
	
	take_kb(kb, from_pos)

	if health <= 0:
		$FlipParent/AnimatedSprite2D.play("death")
		Globals.incr_tyrrany(value)
	else:
		$FlipParent/AnimatedSprite2D.play("hurt")

func _on_animated_sprite_2d_animation_finished() -> void:
	if $FlipParent/AnimatedSprite2D.animation == "death":
		AudioPlayer.slimeDiePlayer.play()
		var t = get_tree().create_tween()
		t.tween_property($FlipParent/AnimatedSprite2D, "modulate", Color(1, 1, 1, 0), 1)
		t.tween_callback(die)
	elif $FlipParent/AnimatedSprite2D.animation != "jump":
		$FlipParent/AnimatedSprite2D.play("jump")

func take_kb(kb, from_pos):
	var direction = (global_position - $FlipParent/damager.parent_body.global_position).normalized()
	knockback_velocity = direction * kb

func die():
	self.queue_free()
