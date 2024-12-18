extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction := 0
var is_throwing = false
var died = false

@onready var anim = $anim

@export var projectile: PackedScene

func _physics_process(delta: float) -> void:
	
	var player = get_parent().get_parent().get_node('player').position
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction == 0 and not died and not is_throwing:
		anim.play('idle')
	
	if died:
		anim.play("die")
	
	if player.x > self.position.x:
		anim.scale.x = -1
	elif player.x < self.position.x:
		anim.scale.x = 1
	
	if is_throwing and $Timer.is_stopped() and not died: 
		anim.play('throw_bomb')
		var projectile_temp = projectile.instantiate()
		
		projectile_temp.position = get_parent().get_node("enemy_with_bomb").position
		get_parent().get_parent().add_child(projectile_temp)
		$Timer.start()
		
	move_and_slide()

func _on_detecting_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		is_throwing = true

func _on_detecting_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		is_throwing = false

func _on_anim_animation_finished() -> void:
	if anim.animation == 'throw_bomb':
		anim.play('idle')
	
	if anim.animation == 'die':
		queue_free()
