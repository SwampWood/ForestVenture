extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimatedSprite2D")
var chase = false
var chase_stop = false
var attacking = false
var can_fire = true
var fire_rate = 2
var speed = 100
var health = 200

var attack = preload("res://enemy_projectile.tscn")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Allies/Druid_male"
	var direction = (player.position - self.position).normalized()
	if chase and not chase_stop and not attacking:
		velocity.x = direction.x * speed
		anim.play("Walk")
	else:
		velocity.x = 0
		if attacking:
			anim.play("Attack")
		else:
			anim.play("Idle")
	if direction.x < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Fireloop()

func Fireloop():
	if chase and not attacking and can_fire:
		attacking = true
		anim.play("Attack")
	elif attacking:
		if $AnimatedSprite2D.frame == 10 and can_fire:
			can_fire = false
			var projectile_instance = attack.instantiate()
			if anim.flip_h:
				projectile_instance.position = self.global_position + Vector2(-22, -8)
			else:
				projectile_instance.position = self.global_position + Vector2(22, -8)
			projectile_instance.rotation = get_angle_to($"../../Allies/Druid_male".global_position)
			get_parent().add_child(projectile_instance)
		if $AnimatedSprite2D.frame == 15:
			attacking = false
			await get_tree().create_timer(fire_rate).timeout
			can_fire = true

func _on_area_2d_2_body_entered(body):
	if body.name == "Druid_male":
		chase_stop = true


func _on_area_2d_2_body_exited(body):
	if body.name == "Druid_male":
		chase_stop = false


func _on_area_2d_body_entered(body):
	if body.name == "Druid_male":
		chase = true


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Druid_male":
		chase = false
