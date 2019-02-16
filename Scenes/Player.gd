extends KinematicBody2D

const SPEED = 300
const GRAVITY = 30
const JUMP_POWER = -750
const FLOOR = Vector2(0, -1)
var RESPAWN_TIME = 1.0
var ATTACK_COOLDOWN = 0.4
var MAX_LIFES = 3
var SPRING_BACK_TIME = 0.7

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

func _physics_process(delta):

	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if not dead:
		if Input.is_action_pressed("ui_right"):
			_move_right()
		elif Input.is_action_pressed("ui_left"):
			_move_left()
		else:
			if not Input.is_action_pressed("ui_select"):
				_set_idle()
			
		if Input.is_action_pressed("ui_select"):
			_attack()

		_update_attack(delta)
		
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
		_update_respawn(delta)

	_update_spring_back(delta)
	
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

func _reset():
	lifes = MAX_LIFES
	get_parent().get_node("GUICanvasLayer").set_hearts(lifes, MAX_LIFES)
	
	
func set_attack_cooldown(sec):
	ATTACK_COOLDOWN = sec
		
func is_attacking():
	return attacking	
	
func _attack():
	if not attacking:
		attacking = true
		$Sword/Sprite/AnimationPlayer.play("attack1")
	
func _update_attack(delta):
	if attacking:
		attack_cooldown_timer += delta
		if attack_cooldown_timer >= ATTACK_COOLDOWN:
			attacking = false
			attack_cooldown_timer = 0.0
			
func _on_Area2D_area_entered(area):
	print("Entered area: " + area.name)
	if area.name == "Area2D_Key":
		_collect_key(area)
	elif area.name == "Area2D_Treasure":
		_open_treasure(area)
	elif area.name == "Area2D_Killing":
		_got_hurt(1)
	elif area.name == "Area2D_Enemy":
		_got_hurt(1)
	elif area.name == "Area2D_PotionSmall":
		_collect_potion_small(area)

func _spring_back():
	$AnimatedSprite/AnimationPlayer.play("got_hurt")
	_move_up(false)
	spring_back = true
	
func _update_spring_back(delta):
	if spring_back:
		#stop spring back
		if spring_back_timer >= SPRING_BACK_TIME:
			spring_back_timer = 0.0
			spring_back = false
		else:
			spring_back_timer += delta
			#move to direction depending on last move
			velocity.x = -last_direction * SPEED
	
func _got_hurt(amount):
	lifes -= amount
	if lifes == 0:
		_die()
	else:	
		_spring_back()
		get_parent().get_node("GUICanvasLayer").set_hearts(lifes, MAX_LIFES)
		
func _collect_key(area):
	print("Got Key!")
	area.get_parent().visible = false
	has_key = true
	
func _collect_potion_small(area):
	area.get_owner().queue_free()
	if lifes < MAX_LIFES:
		lifes += 1
		get_parent().get_node("GUICanvasLayer").set_hearts(lifes, MAX_LIFES)
		
func _open_treasure(area):
	if has_key:
		area.get_parent().get_node("AnimatedSprite").play("open")
		has_key = false
		$Sword.change_type(7)
		print("Opened Treasure!")
	
func _die():
	lifes = 0
	get_parent().get_node("GUICanvasLayer").set_hearts(lifes, MAX_LIFES)
	dead = true
	velocity.x = 0
	$AnimatedSprite.play("dead")
	
func _respawn():
	dead = false
	position = get_parent().get_node("Area2D_Start").position
	_flip_horizontal(false)
	_reset()

func _update_respawn(delta):
	respawn_timer += delta
	if respawn_timer >= RESPAWN_TIME:
		respawn_timer = 0.0
		_respawn()
		
func _flip_horizontal(flip_left):
	if flip_left != is_flipped_left:
		is_flipped_left = flip_left
		#flip player
		$AnimatedSprite.flip_h = flip_left
		#flip sword
		$Sword.apply_scale(Vector2(-1, 1))
		$Sword.position.x = -$Sword.position.x
	
func killed_enemy():
	print("Player killed enemy")