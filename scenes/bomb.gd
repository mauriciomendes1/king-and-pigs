extends RigidBody2D

@onready var collision = $collision
@onready var anim = $anim
@onready var timer = $Timer

var active = true
var body_hurt:CharacterBody2D
var push_force = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var direction = get_parent().get_child(2).get_node('enemy_with_bomb').anim.scale.x
	apply_impulse(Vector2(-direction * 100,-200), Vector2.ZERO)
	await get_tree().create_timer(0.2).timeout
	collision.disabled = false
	timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		anim.play("active")
	else:
		anim.play("boom")
		
func _on_timer_timeout() -> void:
	active = false

	if body_hurt:
		body_hurt.hitted = true
	
func _on_anim_animation_finished() -> void:
	if anim.animation == 'boom':
		queue_free()

func _on_explosion_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body_hurt = body

func _on_explosion_body_exited(body: Node2D) -> void:
	body_hurt = null

func _on_body_entered(body: Node) -> void:
	body.get_tree().get_nodes_in_group('ground')
