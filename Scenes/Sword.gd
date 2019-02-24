extends Node2D

#sword folder
var swords_path_root = "res://Assets/swords/"
#sword files
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
var sword_cooldowns = [0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.7, 0.7]

#attributes of short swords
var sword_short_offset_y = -38
var sword_short_collider_pos = Vector2(-3.3, -56.45034)
var sword_short_collider_scale = Vector2(1.16324, 0.583639)
#attributes of long swords
var sword_long_offset_y = -54
var sword_long_collider_pos = Vector2(-3.3, -77)
var sword_long_collider_scale = Vector2(1.16324, 1.0191)

func _ready():
	change_type( get_node("/root/Global").current_sword_id)
	
func change_type(id):
	print("changing sword type")
	if id == -1:
		visible = false
	elif id < sword_paths.size():
		visible = true
		#set new player attributes
		get_parent().set_attack_cooldown(sword_cooldowns[id])
		#switch texture
		$Sprite.texture = load(swords_path_root + sword_paths[id])
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
	var enemy = area.get_owner()
	if area.name == "Area2D_Enemy":
		if player.is_attacking() and not enemy.dead:
			enemy.die()
			#call function of player
			player.killed_enemy()
