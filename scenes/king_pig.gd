extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -300.0

var direction := 0
var is_attacking = false
var died = false

@onready var attack_detection = $attack_detection
@onready var anim = $anim

func _physics_process(delta: float) -> void:
	
	if not died:
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if attack_detection.is_colliding():
			is_attacking = true
		else:
			is_attacking = false
			
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		if direction and not is_attacking:
			velocity.x = direction * SPEED
			anim.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("idle")
		
		if is_attacking:
			anim.play("attack")
	
	else:
		anim.play("die")

	move_and_slide()


func _on_anim_animation_finished() -> void:
	if anim.animation == 'die':
		queue_free()
