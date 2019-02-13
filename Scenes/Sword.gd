extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	#set idle animation after attack animation finished
	if anim_name == "attack1":
		$Sprite/AnimationPlayer.queue("idle")


func _on_Area2D_Sword_area_entered(area):
	var player = get_parent()
	if area.name == "Area2D_Enemy":
		if player.is_attacking():
			#delete enemy
			area.get_owner().queue_free()
			#call function of player
			player.killed_enemy()
