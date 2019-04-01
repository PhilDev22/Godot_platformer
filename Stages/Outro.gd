extends Node2D

var ready_for_reset = false

func _ready():
	set_coins_collected( get_node("/root/Global").coins )

func set_coins_collected(coins):
	var coins_total = get_node("/root/Global").coins_total
	$CoinsCollected/Label.text = str(coins) + " / " + str(coins_total)
	
func _process(delta):
	if ready_for_reset:
		if Input.is_action_pressed("ui_select"):
			get_node("/root/Global").reset()
			
func _ready_for_reset():
	ready_for_reset = true