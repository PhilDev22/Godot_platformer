extends Node2D

var swords_pth_root = "res://Assets/swords/"
var sword_paths = [
	"sword_bronze1.png", 
	"sword_bronze2.png", 
	"sword_silver1.png", 
	"sword_silver2.png", 
	"sword_gold1.png", 
	"sword_gold2.png", 
	"sword_gold_long1.png",
	"sword_diamond_long1.png"
]

var sword_short_offset_y = -38
var sword_short_collider_pos = Vector2(-3.3, -56.45034)
var sword_short_collider_scale = Vector2(1.16324, 0.583639)

var sword_long_offset_y = -54
var sword_long_collider_pos = Vector2(-3.3, -77)
var sword_long_collider_scale = Vector2(1.16324, 1.0191)

func change_type(id):
	print("changing sword type")
	if id < sword_paths.size():
		#switch texture
		$Sprite.texture = load(swords_pth_root + sword_paths[id])
		#set position of sprite and of colliding area
		if id <= 5: #short sword
			$Sprite.offset.y = sword_short_offset_y
			$Sprite/Area2D_Sword/CollisionShape2D.transform.x = Vector2(sword_short_collider_pos.x, 0)
			$Sprite/Area2D_Sword/CollisionShape2D.transform.y = Vector2(0, sword_short_collider_pos.y)
			$Sprite/Area2D_Sword/CollisionShape2D.scale = sword_short_collider_scale
		elif id > 5: #long sword
			$Sprite.offset.y = sword_long_offset_y
			$Sprite/Area2D_Sword/CollisionShape2D.transform.x = Vector2(sword_long_collider_pos.x, 0)
			$Sprite/Area2D_Sword/CollisionShape2D.transform.y = Vector2(0, sword_long_collider_pos.y)
			$Sprite/Area2D_Sword/CollisionShape2D.scale = sword_long_collider_scale
	else:
		print("Sword id " + id + " could not be loaded!")
	

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
