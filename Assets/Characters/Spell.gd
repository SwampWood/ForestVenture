extends RigidBody2D

const PROJECTILE_SPEED = 350
const LIFETIME = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2(PROJECTILE_SPEED, 0).rotated(rotation))
	SelfDestruct()

func SelfDestruct():
	await get_tree().create_timer(LIFETIME).timeout
	queue_free()

func _on_body_entered(_body):
	self.hide()
