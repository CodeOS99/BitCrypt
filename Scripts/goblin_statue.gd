extends Node2D

@export var p1: Node2D
@export var p2: Node2D

var goblinExplosion = preload("res://Scenes/goblinExplosion.tscn")

func _ready() -> void:
	if Globals.has_goblin_blessing:
		self.visible = true
	else:
		self.visible = false

func _on_player_detector_player_enter() -> void:
	$AnimatedSprite2D.play("active")
	position.y -= 16
	$player_detector.queue_free() # its of no use now
	AudioPlayer.blessingErected.play()

func _on_interact_help_shower_player_interact() -> void:
	Globals.player.camera.start_shake(1.0, 10.0, 5.0)
	var i = goblinExplosion.instantiate()
	get_tree().root.add_child(i)
	AudioPlayer.blessingBlow.play()
	Globals.slime_boss.take_damage(10, 0, Vector2.ZERO)

	var corner_a = p1.position
	var corner_b = p2.position
	var min_x = min(corner_a.x, corner_b.x)
	var max_x = max(corner_a.x, corner_b.x)
	var min_y = min(corner_a.y, corner_b.y)
	var max_y = max(corner_a.y, corner_b.y)

	var rng = RandomNumberGenerator.new()
	var spawn_pos = Vector2(
		rng.randf_range(min_x, max_x),
		rng.randf_range(min_y, max_y)
	)
	position = spawn_pos
