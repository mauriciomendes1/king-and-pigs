extends Node2D


@onready var anim = $anim


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	anim.play('idle')
