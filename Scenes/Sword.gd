extends Node2D

func ready():
	$Sprite/AnimationPlayer.current_animation = "idle"
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack1":
		$Sprite/AnimationPlayer.queue("idle")
