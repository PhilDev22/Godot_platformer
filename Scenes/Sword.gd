extends Node2D

#sword files
var sword_count = 12
var sword_count_short = 8
var swords_path = "res://Assets/items/swords/"
var sword_prefix = "weapon"

var sword_cooldowns = [0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.7, 0.7, 0.7, 0.7]

#attributes of short swords
var sword_short_offset_y = -38
var sword_short_collider_pos = Vector2(-3.3, -56.45034)
var sword_short_collider_scale = Vector2(1.16324, 0.583639)
#attributes of long swords
var sword_long_offset_y = -54
var sword_long_collider_pos = Vector2(-3.3, -77)
var sword_long_collider_scale = Vector2(1.16324, 1.0191)

var attack_phase = false

func _ready():
	change_type( get_node("/root/Global").current_sword_id)
	
func change_type(id):
	print("changing sword type")
	if id == -1:
		visible = false
	elif id < sword_count:
		visible = true
		#set new player attributes
		get_parent().set_attack_cooldown(sword_cooldowns[id])
		#switch texture
		$Sprite.texture = load(swords_path + sword_prefix + str( id + 1 ) + ".png")
		#set position of sprite and of colliding area
		if id <= sword_count_short: #short sword
			$Sprite.offset.y = sword_short_offset_y
			$Sprite/Area2D_Sword/CollisionShape2D.transform.x = Vector2(sword_short_collider_pos.x, 0)
			$Sprite/Area2D_Sword/CollisionShape2D.transform.y = Vector2(0, sword_short_collider_pos.y)
			$Sprite/Area2D_Sword/CollisionShape2D.scale = sword_short_collider_scale
		elif id > sword_count_short: #long sword
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
		var enemy = area.get_owner()
		if not enemy.dead and player.is_attacking() and attack_phase:
			enemy.hit()
			#call function of player
			if enemy.dead:
				player.killed_enemy()
	elif area.name == "Area2D_Destroyable":
		if player.is_attacking() and attack_phase:
			area.get_owner().hit()

func _attack_active():
	print("Attack phase active")
	attack_phase = true
	
func _attack_finished():
	print("Attack phase inactive")
	attack_phase = false