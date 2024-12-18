extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

var died = false
var direction := 0
var is_seeking = false
var is_throwing = false


@export var projectile: PackedScene
@onready var anim = $anim


func _physics_process(delta: float) -> void:
	
	var player = get_parent().get_parent().get_node('player').position
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not died:
		
	
		if direction == 0:
			anim.play('idle')

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if direction and not died:
			velocity.x = direction * SPEED
			anim.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if player.x > self.position.x:
			anim.scale.x = -1
		elif player.x < self.position.x:
			anim.scale.x = 1
			
		if is_seeking:	
			direction = -anim.scale.x
	
	else:
		anim.play("die")
			
	move_and_slide()

func _on_anim_animation_finished() -> void:
	if anim.animation == 'die':
		queue_free()
		
func _on_timer_timeout() -> void:
	pass

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		is_seeking = true
