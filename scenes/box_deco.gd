extends RigidBody2D

var hitted = false
var rng = RandomNumberGenerator.new()

@export var pieces:Array[PackedScene]

@onready var anim = $anim
@onready var main = $'../'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
		
