extends KinematicBody2D

const SPEED = 300
const GRAVITY = 30
const JUMP_POWER = -750
const FLOOR = Vector2(0, -1)
var RESPAWN_TIME = 1.0
var ATTACK_COOLDOWN = 0.4

var velocity = Vector2()

var on_ground = false

var has_key = false
var dead = false
var respawn_timer = 0.0
var attacking = false
var attack_cooldown_timer = 0.0
var is_flipped_left = false

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
			_move_up()
			
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

	velocity.y += GRAVITY	
		
	velocity = move_and_slide(velocity, FLOOR)

func _move_left():
	velocity.x = -SPEED
	$AnimatedSprite.play("run")
	_flip_horizontal(true)
	
func _move_right():
	velocity.x = SPEED
	$AnimatedSprite.play("run")
	_flip_horizontal(false)
	
func _move_up():
	if on_ground:
		velocity.y = JUMP_POWER
		on_ground = false
		
func _set_idle():
	velocity.x = 0
	if on_ground:
		$AnimatedSprite.play("idle")

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
		_die()
	elif area.name == "Area2D_Enemy":
		_die()

func _collect_key(area):
	print("Got Key!")
	area.get_parent().visible = false
	has_key = true
	
func _open_treasure(area):
	if has_key:
		area.get_parent().get_node("AnimatedSprite").play("open")
		has_key = false
		$Sword.change_type(7)
		print("Opened Treasure!")
	
func _die():
	_move_up()
	dead = true
	velocity.x = 0
	$AnimatedSprite.play("dead")
	
func _respawn():
	dead = false
	position = get_parent().get_node("Area2D_Start").position
	_flip_horizontal(false)

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