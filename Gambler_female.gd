extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var attacking = false
var can_fire_green = true
var can_fire_red = 2
var spell_rate = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimatedSprite2D")

var spell = preload("res://spell.tscn")
var spell2 = preload("res://spell2.tscn")

func _process(delta):
	SkillLoop()

func SkillLoop():
	if Input.is_action_pressed("skill") and not attacking and can_fire_green:
		attacking = true
		anim.play("Spell")
	if attacking:
		if $AnimatedSprite2D.frame == 3 and can_fire_green:
			can_fire_green = false
			var projectile_instance1 = spell2.instantiate()
			projectile_instance1.position = self.global_position
			projectile_instance1.rotation = get_angle_to(get_global_mouse_position())
			get_parent().add_child(projectile_instance1)
		if $AnimatedSprite2D.frame == 5 and can_fire_red:
			can_fire_red = false
			var projectile_instance2 = spell.instantiate()
			projectile_instance2.position = self.global_position
			projectile_instance2.rotation = get_angle_to(get_global_mouse_position() + Vector2(22, 8))
			get_parent().add_child(projectile_instance2)
			var projectile_instance3 = spell.instantiate()
			projectile_instance3.position = self.global_position
			projectile_instance3.rotation = get_angle_to(get_global_mouse_position() + Vector2(22, 28))
			get_parent().add_child(projectile_instance3)
			attacking = false
			await get_tree().create_timer(spell_rate).timeout
			can_fire_green = true
			can_fire_red = true
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not attacking:
		velocity.x = direction * SPEED
		if direction == -1:
			anim.flip_h = true
		elif direction == 1:
			anim.flip_h = false
		anim.play("Run")
		anim.set_offset(Vector2(0, 0))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if attacking:
			anim.play("Attack")
			anim.set_offset(Vector2(15, 0))
		else:
			anim.play("Idle")
			anim.set_offset(Vector2(0, 0))

	move_and_slide()
