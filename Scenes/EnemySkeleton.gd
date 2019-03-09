extends Node2D

var HITS_MAX = 3

var hits = 0
var dead = false

var anim_walk_last_pos = 0

func hit():
	print("hit enemy")
	anim_walk_last_pos = $AnimatedSprite/AnimationPlayer.current_animation_position
	$AnimatedSprite/AnimationPlayer.play("hit")
	$Particles2D.emitting = true
	hits += 1
	if hits >= HITS_MAX:
		die()
	
func die():
	dead = true
	$AnimatedSprite/AnimationPlayer.play("die")
	$Particles2D.emitting = true

func _on_AnimationPlayer_animation_finished(anim_name):
	#delete self after death animation finished (waiting for particles to end spreading)
	if anim_name == "die":
		$Particles2D.emitting = false
		queue_free()
	elif anim_name == "hit":
		$AnimatedSprite/AnimationPlayer.play("walk")
		$AnimatedSprite/AnimationPlayer.seek(anim_walk_last_pos)
		$Particles2D.emitting = false
