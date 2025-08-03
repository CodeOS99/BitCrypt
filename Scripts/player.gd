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

var log_label = preload("res://Scenes/log_label.tscn")

var coins: int = 0

func _ready() -> void:
	if Globals.player == null:
		print("real")
		Globals.player = self
		Globals.player_body = self as CharacterBody2D

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
		animation_player.play("walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, WALK_SPEED)
		if animation_player.assigned_animation != "idle":
			animation_player.play("idle")

	move_and_slide()

func add_log(text):
	var l = log_label.instantiate()
	l.text = text
	log_container.add_child(l)
	
func add_coins(n: int):
	coins += n
	add_log("+" + str(n) + " coins")
	coin_amount_label.text = str(coins)
