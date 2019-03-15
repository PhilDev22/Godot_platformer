extends Node2D

var hit = false

func hit():
	if not hit:
		$AnimationPlayer.play("open")
		hit = true

func _destroy():
	queue_free()
