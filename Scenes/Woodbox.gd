extends Node2D

var hit = false

func hit():
	if not hit:
		$AnimationPlayer.play("open")
		$AudioStreamPlayer.playing = true
		hit = true

func _destroy():
	#queue_free()
	pass

func reset():
	hit = false
	$AnimationPlayer.play("reset")
	
	
