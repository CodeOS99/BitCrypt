extends CharacterBody2D

@export var speed: float = 1000.0
@export var stick_on_hit: bool = true

var facing_dir: String
var direction: Vector2
var can_hit_player

func _ready():
	$damager.parent_body = Globals.player
	if facing_dir == "up":
		direction = Vector2.UP
	elif facing_dir == "left":
		direction = Vector2.LEFT
	elif facing_dir == "down":
		direction = Vector2.DOWN
	else:
		direction = Vector2.RIGHT
	rotation = direction.angle()
	velocity = direction.normalized() * speed

func take_damage(a, b, c):
	pass

func take_kb(a,b):
	pass

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)

func _on_damager_hit(body: Node2D) -> void:
	if stick_on_hit:
		velocity = Vector2.ZERO
		get_parent().call_deferred('remove_child', self)
		body.call_deferred('add_child', self)
		global_position = to_local(body.global_position)
		$damager.queue_free()
		$CollisionShape2D.queue_free()
		
		var t = get_tree().create_tween()
		t.tween_property(self, 'modulate', Color(1.0, 1.0, 1.0, 0), 5.0)
		t.tween_callback(self.queue_free)
