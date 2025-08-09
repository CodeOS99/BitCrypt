extends Area2D

signal hit(n: Node2D)

@export var damage: int = 0
@export var parent_body: Node2D
@export var kb: int = 150
@export var self_kb: int = 0

var active: bool = true

func _ready() -> void:
	if damage == 0:
		print("Warning: damage is 0")
	if parent_body == null:
		print("Error: parent_body is null")

func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if _should_damage(body):
			_deal_damage(body)

func _on_body_entered(body: Node2D) -> void:
	if _should_damage(body):
		_deal_damage(body)

func _should_damage(body: Node2D) -> bool:
	if not active or body == parent_body or body == null or parent_body == null:
		return false
	var parent_is_player := parent_body.is_in_group("player")
	var parent_is_enemy := parent_body.is_in_group("enemy")
	var body_is_player := body.is_in_group("player")
	var body_is_enemy := body.is_in_group("enemy")
	return (parent_is_player and body_is_enemy) or (parent_is_enemy and body_is_player)

func _deal_damage(body: Node2D) -> void:
	if body.is_in_group("player"):
		AudioPlayer.hitSound.play()
		Globals.player.camera.start_shake(0.5 , 5.0, 5.0)

	if body.has_method("take_damage"):
		var total_damage := damage
		if parent_body.is_in_group("player"):
			total_damage += Globals.damage
		body.take_damage(total_damage, kb, parent_body.global_position)

	if parent_body.has_method("take_kb"):
		parent_body.take_kb(self_kb, body.global_position)
	print("emitting hit")
	hit.emit(body)
