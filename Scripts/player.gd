class_name Player
extends CharacterBody2D

const WALK_SPEED: float = 100.0
const RUN_SPEED: float = 200.0

var current_speed: float = WALK_SPEED
var can_move: bool = true

@onready var child_parent: Node2D = $childParent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var log_container: VBoxContainer = $Camera2D/CanvasLayer/HUDContainer/logContainer
@onready var coin_amount_label: Label = $Camera2D/CanvasLayer/HUDContainer/CoinAmountShower/CoinAmountLabel
@onready var health_bar: ProgressBar = $HealthBar
@onready var tyrrany_bar: ProgressBar = $Camera2D/CanvasLayer/TyrranyBar

@export var knockback_decay: float = 150.0

var log_label = preload("res://Scenes/log_label.tscn")

var coins: int = 0

var max_health: int = 50
var curr_health: int = max_health

var knockback_velocity: Vector2 = Vector2.ZERO
var move_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if Globals.player == null:
		print("real")
		Globals.player = self
		Globals.player_body = self as CharacterBody2D
	
	health_bar.max_value = max_health
	health_bar.value = health_bar.max_value
	
	tyrrany_bar.max_value = Globals.max_tyrrany
	tyrrany_bar.value = 0

func _physics_process(delta: float) -> void:
	handleMovement(delta)

func handleMovement(delta: float):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	move_velocity = Vector2.ZERO

	if knockback_velocity.length() > 0.1:
		move_velocity += knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	else:
		knockback_velocity = Vector2.ZERO

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
		move_velocity += input_vector * current_speed
		animation_player.play("walk")
	else:
		if animation_player.assigned_animation != "idle":
			animation_player.play("idle")

	velocity = move_velocity
	move_and_slide()

func add_log(text):
	var l = log_label.instantiate()
	l.text = text
	log_container.add_child(l)
	
func add_coins(n: int):
	coins += n
	add_log("+" + str(n) + " coins")
	coin_amount_label.text = str(coins)

func take_damage(n: int, kb: int, from_pos:Vector2):
	if animation_player.current_animation != "hurt":
		curr_health -= n
		animation_player.play("hurt")
		can_move = false
		health_bar.value = curr_health

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		can_move = true

func update_tyrrany(n: int):
	tyrrany_bar.value = n

func become_tyrranous():
	print("oooooooo tyrrany!!!!")

func take_kb(kb: int, from_pos: Vector2):
	var direction = (global_position - from_pos).normalized()
	knockback_velocity = direction * kb
