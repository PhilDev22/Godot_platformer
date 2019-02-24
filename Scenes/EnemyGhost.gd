extends Node2D

var dead = false

func die():
	dead = true
	#stop movement and current animation and play death animation
	$AnimatedSprite.play("dead")
	$AnimatedSprite/AnimationPlayer_Pulsate.stop(true)
	$AnimatedSprite/AnimationPlayer_Movement.play("die")

func _on_AnimationPlayer_Movement_animation_finished(anim_name):
	if anim_name == "die":
		#delete enemy after death animation finished
		queue_free()
