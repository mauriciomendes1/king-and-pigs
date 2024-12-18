extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var direction := 0
var is_attacking = false
var hitted = false
var push_force = 50

@onready var anim = $anim
@onready var hit_box = $hitbox/collision


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if not is_attacking:
			anim.play('jump')

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("attack2"):
		is_attacking = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction == 0:
		if not is_attacking and is_on_floor() and not hitted:
			anim.play('idle')
	if direction != 0:
		if not is_attacking and is_on_floor() and not hitted:
			anim.play('run')
	
	if is_attacking and not hitted:
		anim.play('attack')
		hit_box.disabled = false
		
	if direction < 0:
		anim.scale.x = -1
		hit_box.position.x = -41
	elif direction > 0:
		anim.scale.x = 1
		hit_box.position.x = 27.5
	
	if hitted:
		anim.play("hitted")
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i)
		if collider.get_collider() is RigidBody2D:
			collider.get_collider().apply_central_impulse(-collider.get_normal() * push_force)

func _on_anim_animation_finished() -> void:
	if anim.animation == 'attack':
		is_attacking = false
		hit_box.disabled = true
	if anim.animation == 'hitted':
		hitted = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemies'):
		body.died = true
		
	if body.is_in_group('bomb'):
		body.apply_impulse(Vector2(direction * (push_force * 5), -300), Vector2.ZERO)
	
	if body.is_in_group('box'):
		body.hitted = true
	
	if body.is_in_group('bomb_deco'):
		body.active = true
		body.apply_impulse(Vector2(direction * (push_force * 5), -300), Vector2.ZERO)
		body.timer.start()
		
	if body.is_in_group('box_deco'):
		body.hitted = true


func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group('bomb'):
		body.apply_impulse(Vector2(direction * 100, 0), Vector2.ZERO)
