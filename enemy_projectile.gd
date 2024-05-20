extends RigidBody2D

var projectile_speed = 400
var lifetime = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2(projectile_speed, 0).rotated(rotation))
	SelfDestruct()

func SelfDestruct():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	self.hide()
