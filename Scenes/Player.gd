extends KinematicBody2D

onready var scn_poup_items = preload("res://Scenes/PopupItems.tscn")

const SPEED = 300
const GRAVITY = 30
const JUMP_POWER = -750
const FLOOR = Vector2(0, -1)
var RESPAWN_TIME = 1.0
var ATTACK_COOLDOWN = 0.4
var MAX_LIFES = 3
var SPRING_BACK_TIME = 0.7
var HURT_COOLDOWN = 0.2

var velocity = Vector2()

var on_ground = false

var has_key = false
var dead = false
var respawn_timer = 0.0
var attacking = false
var attack_cooldown_timer = 0.0
var is_flipped_left = false
var lifes = MAX_LIFES
var last_direction = 1
var spring_back = false
var spring_back_timer = 0.0
var just_got_hurt = false
var hurt_cooldown_timer = 0.0
var popup_active = false

func ready():
	position = get_parent().get_node("Area2D_Start").position
	
func _physics_process(delta):

	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	# get input for controlling player
	if not popup_active:
		if not dead:
			if Input.is_action_pressed("ui_right"):
				_move_right()
			elif Input.is_action_pressed("ui_left"):
				_move_left()
			else:
				if not Input.is_action_pressed("ui_select"): #if not attacking
					_set_idle()
			
			# attack when pressed space
			if Input.is_action_pressed("ui_select"):
				_attack()
			# update attacking movement
			_update_attack(delta)
			
			# jump
			if Input.is_action_pressed("ui_up"):
				_move_up(true)
				
			if is_on_floor():
				on_ground = true
			else:
				on_ground = false
				if velocity.y < 0:
					$AnimatedSprite.play("jump")
				else:
					$AnimatedSprite.play("fall")
	
		else: #dead
			# update respawn timer
			_update_respawn(delta)
			
		#update spring-back movement after player got hurt
		_update_spring_back(delta)
		#update hurt-cooldown, to avoid being hurt multiple times
		_update_hurt_cooldown(delta)
		
		#update player movement
		velocity.y += GRAVITY	
		velocity = move_and_slide(velocity, FLOOR)
			
func _move_left():
	if not spring_back:
		last_direction = -1
		velocity.x = -SPEED
		$AnimatedSprite.play("run")
		_flip_horizontal(true)
	
func _move_right():
	if not spring_back:
		last_direction = 1
		velocity.x = SPEED
		$AnimatedSprite.play("run")
		_flip_horizontal(false)
	
func _move_up(when_on_ground):
	if !when_on_ground or (when_on_ground and on_ground):
		velocity.y = JUMP_POWER
		on_ground = false
		
func _set_idle():
	velocity.x = 0
	if on_ground:
		$AnimatedSprite.play("idle")

func _update_spring_back(delta):
	if spring_back:
		# stop springing back
		if spring_back_timer >= SPRING_BACK_TIME:
			spring_back_timer = 0.0
			spring_back = false
		else:
			spring_back_timer += delta
			# move to direction depending on last move
			velocity.x = -last_direction * SPEED
	
func _update_hurt_cooldown(delta):
	# avoid getting hurt twice when colliding 
	# with 2 obstacles at the same time
	if just_got_hurt:
		hurt_cooldown_timer += delta
		if hurt_cooldown_timer >= HURT_COOLDOWN:
			hurt_cooldown_timer = 0.0
			just_got_hurt = false

func _update_attack(delta):
	if attacking:
		attack_cooldown_timer += delta
		if attack_cooldown_timer >= ATTACK_COOLDOWN:
			attacking = false
			attack_cooldown_timer = 0.0

func _update_respawn(delta):
	respawn_timer += delta
	if respawn_timer >= RESPAWN_TIME:
		respawn_timer = 0.0
		_respawn()

func _reset():
	lifes = MAX_LIFES
	_update_gui_lifes()
	
func set_attack_cooldown(sec):
	ATTACK_COOLDOWN = sec

func is_attacking():
	return attacking	
	
func _attack():
	if not attacking and $Sword.visible == true:
		attacking = true
		$Sword/Sprite/AnimationPlayer.play("attack1")

func _next_level():
	get_node("/root/Global").load_next_level()
	
func _spring_back():
	$AnimatedSprite/AnimationPlayer.play("got_hurt")
	_move_up(false)
	spring_back = true
	
func _got_hurt(amount):
	if not just_got_hurt:
		just_got_hurt = true
		lifes -= amount
		if lifes == 0:
			_die()
		else:	
			_spring_back()
			_update_gui_lifes()
		
func _got_hurt_by_enemy(enemy_area):
	if not enemy_area.get_owner().dead:
		_got_hurt(1)
	
func _collect_key(area):
	area.get_parent().visible = false
	has_key = true
	
func _collect_potion_small(area):
	area.get_owner().queue_free()
	$Particles2D_Potion.emitting = true
	if lifes < MAX_LIFES:
		lifes += 1
		_update_gui_lifes()

# play opening animation and show popup
func _open_treasure(area):
	if has_key:
		$AnimatedSprite.play("idle")
		area.get_parent().get_node("AnimatedSprite").play("open")
		has_key = false
		_show_item_popup()

func on_close_item_popup():
	popup_active = false
	$Particles2D.emitting = true

# load popup for choosing new item, depending on current stage
func _show_item_popup():
	var popup = scn_poup_items.instance()
	popup.set_name("PopupItems")
	popup.set_position(Vector2(640, 360))
	get_parent().get_node("GUICanvasLayer").add_child(popup)
	popup.init_items( get_node("/root/Global").current_level )
	popup_active = true

# increase amount of lifes (hearts) and update gui
func _increase_life_permanent(amount):
	for i in amount:
		lifes += 1
		get_parent().get_node("GUICanvasLayer").add_heart()

#reduce lifes, stop movement, play death animation		
func _die():
	lifes = 0
	_update_gui_lifes()
	dead = true
	velocity.x = 0
	$AnimatedSprite.play("dead")
	
func _respawn():
	dead = false
	position = get_parent().get_node("Area2D_Start").position
	_flip_horizontal(false)
	_reset()

func _flip_horizontal(flip_left):
	if flip_left != is_flipped_left:
		is_flipped_left = flip_left
		#flip player
		$AnimatedSprite.flip_h = flip_left
		#flip sword
		$Sword.apply_scale(Vector2(-1, 1))
		$Sword.position.x = -$Sword.position.x
	
func _update_gui_lifes():
	#update amount of hearts showing at the gui
	get_parent().get_node("GUICanvasLayer").set_active_hearts(lifes)
	
func killed_enemy():
	print("Player killed enemy")
	
func _on_Area2D_area_entered(area):
	print("Entered area: " + area.name)
	if area.name == "Area2D_Key":
		_collect_key(area)
	elif area.name == "Area2D_Treasure":
		_open_treasure(area)
	elif area.name == "Area2D_Killing":
		_got_hurt(1)
	elif area.name == "Area2D_Enemy":
		_got_hurt_by_enemy(area)
	elif area.name == "Area2D_PotionSmall":
		_collect_potion_small(area)
	elif area.name == "Area2D_Exit":
		_next_level()