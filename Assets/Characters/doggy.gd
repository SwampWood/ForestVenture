extends CharacterBody2D


const SPEED = 280
const JUMP_VELOCITY = -400.0
@onready var player = $"../../Allies/Tamer_male"
@onready var anim = get_node("AnimatedSprite2D")
var idle = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction = (player.position - self.position).normalized()
	if idle:
		velocity.x -= direction.x * 10
		if abs(velocity.x) <= 20:
			velocity.x = 0
		
		anim.play("Idle")
	else:
		velocity.x = direction.x * SPEED
		anim.play("Run")
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Tamer_male":
		idle = true
		anim.play("Run")


func _on_area_2d_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Tamer_male":
		idle = false
