extends Node2D

var dead = false

func hit():
	die()
	
func die():
	dead = true
	#stop movement and current animation and play death animation
	$AnimatedSprite.play("dead")
	$AnimatedSprite/AnimationPlayer_Pulsate.stop(true)
	$AnimatedSprite/AnimationPlayer_Movement.play("die")
	$AnimatedSprite/Particles2D.emitting = true

func _on_AnimationPlayer_Movement_animation_finished(anim_name):
	#delete self after death animation finished
	if anim_name == "die":
		queue_free()