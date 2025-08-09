extends Node2D

var enemy_pool = [
	#{
		#scene = preload("res://Scenes/enemies/bat_enemy.tscn"),
		#power = 1
	#},
	{
		scene = preload("res://Scenes/enemies/slime_enemy.tscn"),
		power = 1
	},
	{
		scene = preload("res://Scenes/enemies/bigger_slime_enemy.tscn"),
		power = 3
	},
	{
		scene = preload("res://Scenes/enemies/biggest_slime_enemy.tscn"),
		power = 7
	}
]

@export var p1: Node2D
@export var p2: Node2D
@export var power_budget: int = 10

func spawn_enemies_in_area() -> void:
	var corner_a = p1.position
	var corner_b = p2.position
	var min_x = min(corner_a.x, corner_b.x)
	var max_x = max(corner_a.x, corner_b.x)
	var min_y = min(corner_a.y, corner_b.y)
	var max_y = max(corner_a.y, corner_b.y)

	var available_budget = power_budget
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	while available_budget > 0:
		var affordable_enemies = enemy_pool.filter(func(enemy): return enemy.power <= available_budget)

		if affordable_enemies.is_empty():
			break 

		var chosen = affordable_enemies[rng.randi() % affordable_enemies.size()]
		var instance = chosen.scene.instantiate()
		var spawn_pos = Vector2(
			rng.randf_range(min_x, max_x),
			rng.randf_range(min_y, max_y)
		)

		instance.global_position = spawn_pos
		add_child(instance)
		available_budget -= chosen.power
