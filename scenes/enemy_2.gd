extends CharacterBody2D

@onready var anim = $anim
@onready var timer = $Timer

@export var box:PackedScene

var died = false
var throw = false

func _physics_process(delta: float) -> void:
	var player = get_parent().get_parent().get_node('player')
	
	if not died and not throw:
		anim.play("idle")
		
	if died:
		anim.play("die")
	
	if throw and timer.is_stopped():
		anim.play('throw')
		var box_temp = box.instantiate()
		box_temp.position = get_parent().get_node('enemy_2').position
		get_parent().get_parent().add_child(box_temp)
		timer.start()
		
	if player.position.x > position.x:
		anim.scale.x = -1
	else:
		anim.scale.x = 1

func _on_anim_animation_finished() -> void:
	if anim.animation == 'die':
		queue_free()
	
	if anim.animation == 'throw':
		anim.play('idle')

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		throw = true

func _on_timer_timeout() -> void:
	pass

func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		throw = false
