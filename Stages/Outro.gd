extends Node2D

var ready_for_reset = false

func _ready():
	set_coins( get_node("/root/Global").coins )

func set_coins(coins):
	$CoinsCollected/Label.text = str(coins)
	
func _process(delta):
	if ready_for_reset:
		if Input.is_action_pressed("ui_select"):
			get_node("/root/Global").reset()
			
func _ready_for_reset():
	ready_for_reset = true