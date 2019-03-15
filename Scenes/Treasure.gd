extends Node2D

var opened = false

func _ready():
	get_node("SpriteHelp").visible = false
	
func open():
	get_node("AnimatedSprite").play("open")
	opened = true
	

