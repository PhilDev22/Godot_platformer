extends Node2D

var opened = false

func _ready():
	get_node("SpriteHelp").visible = false
	
func open():
	get_node("AnimatedSprite").play("open")
	opened = true
	
func show_hint():
	get_node("SpriteHelp/AnimationPlayer").play("show")

