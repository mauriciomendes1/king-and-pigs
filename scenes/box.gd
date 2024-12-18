extends RigidBody2D

var rng = RandomNumberGenerator.new()
var hitted = false

@export var pieces:Array[PackedScene]

@onready var main = $'../'
@onready var anim = $anim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_pos = rng.randf_range(200.0, 350.0)
	var direction = get_parent().get_child(2).get_node('enemy_2').anim.scale.x
	apply_impulse(Vector2(-direction * random_pos, -100), Vector2.ZERO)
	print(main)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not hitted:
		anim.play("idle")
	else:
		anim.play('hit')

func _on_anim_animation_finished() -> void:
	if anim.animation == 'hit':
		hitted = false
		queue_free()
		
		for i in pieces:
			var rand = rng.randf_range(100.0, -100.0)
			var piece_temp = i.instantiate()
			piece_temp.position = self.position
			piece_temp.apply_impulse(Vector2(rand, rand), Vector2.ZERO)
			main.add_child(piece_temp)
		
