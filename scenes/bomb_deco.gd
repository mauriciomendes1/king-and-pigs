extends RigidBody2D

var active = false
var body_hurt:CharacterBody2D

@onready var anim = $anim
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		anim.play('active')
		

func _on_explosion_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body_hurt = body
		active = true
		timer.start()

func _on_timer_timeout() -> void:
	active = false
	anim.play('boom')
	if body_hurt:
		body_hurt.hitted = true

func _on_anim_animation_finished() -> void:
	if anim.animation == 'boom':
		queue_free()

func _on_explosion_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		body_hurt = null
		
