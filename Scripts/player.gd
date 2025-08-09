class_name Player
extends CharacterBody2D

const WALK_SPEED: float = 100.0
const RUN_SPEED: float = 200.0

var current_speed: float = WALK_SPEED
var can_move: bool = true

@onready var child_parent: Node2D = $childParent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var log_container: VBoxContainer = $Camera2D/playerUI/HUDContainer/logContainer
@onready var coin_amount_label: Label = $Camera2D/playerUI/HUDContainer/CoinAmountShower/CoinAmountLabel
@onready var health_bar: ProgressBar = $HealthBar
@onready var tyrrany_bar: ProgressBar = $Camera2D/playerUI/HUDContainer/TyrranyBar
@onready var weapon_parent_node: Node2D = $weapon
@onready var arrow_amount_label: Label = $Camera2D/playerUI/HUDContainer/ArrowAmountShower/ArrowAmountLabel
@onready var camera: Camera2D = $Camera2D

@export var knockback_decay: float = 150.0

var log_label = preload("res://Scenes/log_label.tscn")
var bow = preload("res://Scenes/weapons/bow.tscn")
var sword = preload("res://Scenes/weapons/sword.tscn")

var coins: int = 0

var max_health: int = 50
var curr_health: int = max_health

var knockback_velocity: Vector2 = Vector2.ZERO
var move_velocity: Vector2 = Vector2.ZERO

var is_hurting: bool = false

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

	# Apply knockback decay
	if knockback_velocity.length() > 0.1:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	else:
		knockback_velocity = Vector2.ZERO

	# Movement input
	var input_vector := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()

	move_velocity = input_vector * current_speed

	# Flip sprite if moving horizontally
	if input_vector.x != 0:
		child_parent.scale.x = abs(child_parent.scale.x) * sign(input_vector.x)

	# Animation
	if input_vector.length() > 0 and not is_hurting:
		animation_player.play("walk")
	elif not is_hurting and animation_player.assigned_animation != "idle":
		animation_player.play("idle")

	# Combine movement and knockback
	velocity = move_velocity + knockback_velocity

	# Let Godot handle sliding and collision detection
	move_and_slide()

func add_log(text):
	var l = log_label.instantiate()
	l.text = text
	log_container.add_child(l)
	
func add_coins(n: int):
	coins += n
	add_log("+" + str(n) + " coins")
	coin_amount_label.text = str(coins)

func take_damage(n: int, kb: int, from_pos: Vector2):
	if not is_hurting:
		curr_health -= n
		animation_player.play("hurt")
		is_hurting = true
		take_kb(kb, from_pos)
		health_bar.value = curr_health
		$CollisionShape2D.set_deferred('disabled', true) # i frames
		can_move = true
	if curr_health <= 0:
		Engine.time_scale = 0.1
		camera.zoom = Vector2(18, 18)
		animation_player.play("dead")
		AudioPlayer.play_game_over_music()
		$Camera2D/playerUI/redOverlay.visible = true

func heal(n: int):
	curr_health = min(curr_health+n, max_health)
	health_bar.value = curr_health

func buy_of(cost: int):
	coins -= cost
	coin_amount_label.text = str(coins)

func equip(weapon: String):
	weapon_parent_node.get_child(0).queue_free() # delete the current one
	var spawned
	if weapon == "bow":
		spawned = bow.instantiate()
		weapon_parent_node.add_child(spawned)
	elif weapon == "sword":
		spawned = sword.instantiate()
		weapon_parent_node.add_child(spawned)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		is_hurting = false
		$CollisionShape2D.disabled = false
	elif anim_name == "dead":
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		get_parent().queue_free()
func update_tyrrany(n: int):
	tyrrany_bar.value = n

func become_tyrranous():
	AudioPlayer.tyrranyMaxPlayer.play()

func take_kb(kb: int, from_pos: Vector2):
	var direction = (global_position - from_pos).normalized()
	knockback_velocity = direction * kb

func incr_max_health(n: int):
	max_health += n
	health_bar.max_value = max_health

func incr_dmg (n: int):
	Globals.damage += n

func gain_arrows(n: int):
	Globals.arrows += n
	arrow_amount_label.text = str(Globals.arrows)
